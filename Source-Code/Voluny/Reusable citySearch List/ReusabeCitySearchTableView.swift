//
//  ReusabeCitySearchTableView.swift
//  Voluny
//


import UIKit
import GooglePlaces
import CoreLocation
import Firebase
import Alamofire
import SwiftyJSON

class ReusabeCitySearchTableView: NSObject, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GMSAutocompleteFetcherDelegate {

    var tableView: UITableView
    
    var tableData = [String]() // Stores the autocompletion results
    var fetcher: GMSAutocompleteFetcher? // Google api - auto completion fetcher
    
    // Reverse Geocoding tools
    let locationManager = CLLocationManager()
    var placemark: CLPlacemark?
    var geocoder = CLGeocoder()
    var location: CLLocation? // Stores the coordinates
    var city: String? // Stores the city after reverse geocoding
    var country: String? // Stores the country after reverse geocoding
    var timer: Timer? // Used to stop the location retrievel after 10 seconds
    
    var citySearchProtocol: CitySearchProtocol?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        tableData.append("Use current location")
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "CitySearchCell", bundle: nil), forCellReuseIdentifier: "CitySearchCell")
        self.tableView.reloadData()
        
        // Configuring the auto completion fetcher
        let neBoundsCorner = CLLocationCoordinate2D(latitude: -33.843366, longitude: 151.134002)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: -33.875725, longitude: 151.200349)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,coordinate: swBoundsCorner)
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
    }
    
    // MARK: Controlling the location manager
    func checkLocationAccess(){
        let authStatus = CLLocationManager.authorizationStatus() // Getting the current access status
        
        if authStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        
        if authStatus == .denied || authStatus == .restricted{
            citySearchProtocol?.locationDenied()
            return
        }
        startLocationManager() // We have access to user's location
    }
    
    func startLocationManager(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            location = nil // Removing any previous location value
            placemark = nil
            print("Location retrieval started...")
            locationManager.startUpdatingLocation()
            citySearchProtocol?.showInidicatorAcitivity(show: true)
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false) // We stop the location retrieval process after 10 seconds
        }
    }
    
    func stopLocationManager(){
        print("Location retrieval stopped...")
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        if let timer = timer{
            timer.invalidate()
        }
        
        guard let location = location else { // We make sure we have a corrrect location
            citySearchProtocol?.errorGettingLocation()
            return
        }
        
        performReverseGeocoding(location: location)
    }
    
    @objc func didTimeOut(){
        print("Time out")
        if location == nil{
            stopLocationManager()
            citySearchProtocol?.errorGettingLocation()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitySearchCell") as! CitySearchCell
        
        if tableData.count-1 >= indexPath.row{
            if indexPath.row == 0{
                cell.configureCell(isCity: false, text: tableData[indexPath.row])
            }else{
                cell.configureCell(isCity: true, text: tableData[indexPath.row])
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableData.count-1 >=  indexPath.row{
            if tableData[indexPath.row] == "Use current location"{
                citySearchProtocol?.suggestionViewShow(show: false)
                checkLocationAccess() // Start the location retrieval process
            }else{
                citySearchProtocol?.textFieldDidRecieveCity(text: tableData[indexPath.row])
                citySearchProtocol?.enableActionButton?(enable: true)
                citySearchProtocol?.suggestionViewShow(show: false)
            }
        }
    }
    
    // MARK: CLLocationManager Delegate methods and reverse geocoding
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed with error: \(error)")
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("reading user location")
        if let lastLocation = locations.last{ // Getting the latest received location
            
            if lastLocation.horizontalAccuracy < 0 { // if it's less than 0, coordinates are invalid
                return
            }
            
            // If no location was set yet or new location is more accurate (a larger accuracy value means less accurate)
            if location == nil || location!.horizontalAccuracy > lastLocation.horizontalAccuracy{
                location = lastLocation
                
                // If new location's accuracy is equal to or better than the desired accuracy, stop the location manager
                if lastLocation.horizontalAccuracy <= locationManager.desiredAccuracy{
                    // We're done, we have enough accuracy
                    print("Desired accuracy achieved")
                    stopLocationManager()
                }
            }
            
        }
    }
    
    func performReverseGeocoding(location: CLLocation){ // We call this function after we finished receiving the user's location - so we only call it once
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            print("Submitting a request to apple's servers for geocoding")
            if error == nil, let placemark = placemarks, !placemark.isEmpty{
                self.placemark = placemark.last
            }else{
                self.placemark = nil
            }
            self.parsePlacemarks()
            self.citySearchProtocol?.showInidicatorAcitivity(show: false)
        }
    }
    
    func parsePlacemarks() {
        // Check if we have a location received
        if let _ = location {
            if let placemark = placemark {
                // City name = locality
                // Country name = isoCountryCode
                if let city = placemark.locality, !city.isEmpty, let countryShortName = placemark.isoCountryCode, !countryShortName.isEmpty {
                    self.city = city
                    self.country = countryShortName
                    print("City: \(city)")
                    print("Country: \(countryShortName)")
                    self.citySearchProtocol?.textFieldDidRecieveCity(text: "\(city), \(countryShortName)")
                    self.citySearchProtocol?.enableActionButton?(enable: true)
                }else{ // Unable to get city and country
                    print("Unable to get city and country")
                    citySearchProtocol?.errorGettingLocation()
                }
            }else{ // Placemark is nil
                print("Placemark is nil")
                citySearchProtocol?.errorGettingLocation()
            }
        } else {
            print("For some reason location is nil")
        }
        
    }
    
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        tableData.removeAll()
        tableData.append("Use current location")
        print("Predictions count: ", predictions.count)
        
        for prediction in predictions {
            // At this point, we received the auto completion results in the prediction array, and each prediction has a Place ID, and we need to get city/country information from that ID and we use reverse geocoding API to receive JSON of the place's address details
            let yourAPi = ""
            let url = "https://maps.googleapis.com/maps/api/geocode/json?place_id=\(prediction.placeID!)&key=\(yourAPi)"
            print("Loading autocompletion details using geocoding...")
            Alamofire.request(url, method: .get).validate().responseJSON { (response) in
                print("Alamofire request sent...")
                if let value = response.result.value {
                    let json = JSON(value)
                    for each in 0...json["results"][0]["address_components"].count{
                        if json["results"][0]["address_components"][each]["types"][0] == "country"{
                            let countryCode = json["results"][0]["address_components"][each]["short_name"].stringValue
                            
                            if self.tableData.contains("\(prediction.attributedPrimaryText.string), \(countryCode)") == false{
                                self.tableData.append("\(prediction.attributedPrimaryText.string), \(countryCode)")
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        citySearchProtocol?.didFailAutoComplete(error: error)
        print(error.localizedDescription)
    }
    
    
}

@objc protocol CitySearchProtocol {
    // VC should do an alert controller
    func locationDenied()
    
    // VC should stop the indicator if show is false
    func showInidicatorAcitivity(show: Bool)
    
    // VC should stop the indicator, remove the text from textfield, and disable the actionbutton and present an unable to access search mannually alert controller
    func errorGettingLocation()
    
    // VC should hide the suggestion view if false
    func suggestionViewShow(show: Bool)
    
    // VC should update the textfield text
    func textFieldDidRecieveCity(text: String)
    
    // VC should enable action button if true
    @objc optional func enableActionButton(enable: Bool)
    
    // Autocomplete failed
    func didFailAutoComplete(error: Error)
}
