//
//  WalkthroughLocationVC
//  Voluny
//


import UIKit
import GooglePlaces
import CoreLocation
import Firebase
import Alamofire
import SwiftyJSON

class WalkthroughLocationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var suggestionsView: WalkthroughShadowView!
    @IBOutlet weak var submitButton: WalkthroughRoundedButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var tableData = [String]() // Stores the autocompletion results
    var fetcher: GMSAutocompleteFetcher? // Google api - auto completion fetcher
    var isSignUp = false // True if it's used for selecting a city for user account setup process
    
    // Reverse Geocoding tools
    let locationManager = CLLocationManager()
    var placemark: CLPlacemark?
    var geocoder = CLGeocoder()
    var location: CLLocation? // Stores the coordinates
    var city: String? // Stores the city after reverse geocoding
    var country: String? // Stores the country after reverse geocoding
    var timer: Timer? // Used to stop the location retrievel after 10 seconds
    
    // Indicator Views
    var indicatorBackground: UIView!
    var activityIndicator: UIActivityIndicatorView!
    
    var isInternetAvailable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Table view setup
        tableView.delegate = self
        tableView.dataSource = self
        tableData.append("Use current Location") // The suggestions view will always have this as the first row
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
        
        locationTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        setupIndicatorViews() // Setting up the activity indicator view and its background view
        locationTextField.modifyClearButton(with: UIImage(named: "Button: Cancel.png")!) // Setting a custom clear button for the text field
        
        // Configuring the auto completion fetcher
        let neBoundsCorner = CLLocationCoordinate2D(latitude: -33.843366, longitude: 151.134002)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: -33.875725, longitude: 151.200349)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,coordinate: swBoundsCorner)
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if isSignUp == true{ // We are using this screen to update the user's location setting
            submitButton.setTitle("SELECT CITY", for: .normal)
            closeButton.isHidden = false
        }
        
    }
    
    // MARK: Checking if user is logged in and isSignUp value
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setting button status
        setActionButton(locationTextField.hasText)
        
        if isSignUp == false{ // This screen is a get started screen now
            for view in self.view.subviews as[UIView]{
                view.isHidden = true
            }
            
            // Check if user already saw the welcome screens
            if UserDefaults.standard.bool(forKey: "welcomeShown") == false{
                UserDefaults.standard.set(true, forKey: "welcomeShown")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let welcomeVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                self.present(welcomeVC, animated:false, completion:nil)
                return
            }
            
            //UserDefaults.standard.set(false, forKey: "welcomeShown")
            
            if Auth.auth().currentUser != nil{ // If user is logged in, we need to transfer the user to another screen
                transferLoggedInUser()
            }else{ // User is not logged in, user stays on this screen
                for view in self.view.subviews as[UIView]{
                    view.isHidden = false
                }
                suggestionsView.isHidden = true
                closeButton.isHidden = true
            }
        }
    }
    
    func transferLoggedInUser(){
        if Auth.auth().currentUser?.isAnonymous == true{ // If user is a guest user
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "home")
            DispatchQueue.main.async {
                self.present(homeVC!, animated: false, completion: nil)
            }
        }else{ // User is not a guest user, we need to check if it's a volunteer or a recruiter
            DataService.instance.isUserVolunteer(uid: (Auth.auth().currentUser?.uid)!, handler: { (isVolunteer) in
                
                if isVolunteer == true{ // Logged in user is a volunteer, take it to the volunteer screen
                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "home")
                    DispatchQueue.main.async {
                        self.present(homeVC!, animated: false, completion: nil)
                    }
                }else{ // Logged in user is a recruiter, take it to the recruiter screen
                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "recruiterHome")
                    DispatchQueue.main.async {
                        self.present(homeVC!, animated: false, completion: nil)
                    }
                }
                
            })
        }
    }
    
    // MARK: Controlling the location manager
    func checkLocationAccess(){
        let authStatus = CLLocationManager.authorizationStatus() // Getting the current access status
        
        if authStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        
        if authStatus == .denied || authStatus == .restricted{
            let alertVC = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
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
            showIndicatorActivity(true)
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
            errorGettingLocation()
            return
        }
        
        performReverseGeocoding(location: location)
    }
    
    @objc func didTimeOut(){
        print("Time out")
        if location == nil{
            stopLocationManager()
            errorGettingLocation()
        }
    }
    
    func errorGettingLocation(){
        showIndicatorActivity(false)
        locationTextField.text = ""
        setActionButton(false)
        let alertVC = UIAlertController(title: "Unable to access your location", message: "Please search for a city manually by typing", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: Managing the Activity Indicator
    func setupIndicatorViews(){
        indicatorBackground = UIView(frame: view.bounds)
        indicatorBackground.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.203537632)
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x-18, y: view.center.y-18, width: 36, height: 36))
        activityIndicator.style = .whiteLarge
        indicatorBackground.addSubview(activityIndicator)
    }
    
    func showIndicatorActivity(_ show: Bool){
        if show{
            view.addSubview(indicatorBackground)
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        }else{ // remove the indicator
            indicatorBackground.removeFromSuperview()
            activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
        }
    }


    // MARK: TextField Delegate Methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        if locationTextField.text == ""{
            locationTextField.rightViewMode = .whileEditing
            setActionButton(false)
        }else{
            locationTextField.rightViewMode = .always
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !Reachability.isConnectedToNetwork(){ // We don't have internet connection
            let alertVC = UIAlertController(title: "No Internet Connection!", message: "Please connect to the internet to use Voluny", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
            textField.resignFirstResponder()
            isInternetAvailable = false
        }else{
            isInternetAvailable = true
        }
        locationTextField.rightViewMode = .whileEditing
    }
    
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        if isInternetAvailable{
            fetcher?.sourceTextHasChanged(locationTextField.text!) // Updating the auto completion results
        }
        
        if locationTextField.text == ""{
            suggestionsView.isHidden = true
            setActionButton(false)
        }else{
            suggestionsView.isHidden = false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: TableView Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LocationSuggestionCell
        
        if tableData.count-1 >= indexPath.row{
            cell.label.text = tableData[indexPath.row]
            
            if indexPath.row == 0{
                cell.label.textColor = #colorLiteral(red: 0.831372549, green: 0.2745098039, blue: 0.4196078431, alpha: 1)
            }else{
                cell.label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableData.count-1 >= indexPath.row{
            if tableData[indexPath.row] == "Use current location"{
                suggestionsView.isHidden = true
                checkLocationAccess() // Start the location retrieval process
            }else{
                locationTextField.text = tableData[indexPath.row]
                setActionButton(true)
                suggestionsView.isHidden = true
            }
        }
    }
    
    
    // User taps the action button
    @IBAction func startedTapped(_ sender: Any) {
        if isSignUp == false{
            if locationTextField.text != ""{
                performSegue(withIdentifier: "UserTypeVC", sender: nil)
                UserDefaults.standard.set(locationTextField.text, forKey: "location")
            }
        }else{
            if locationTextField.text != ""{
                NotificationCenter.default.post(name: Notification.Name("locationChanged"), object: locationTextField.text)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setActionButton(_ enabled: Bool){
        if enabled{
            submitButton.alpha = 1.0
            submitButton.isEnabled = true
        }else{
            submitButton.alpha = 0.65
            submitButton.isEnabled = false
        }
    }
    
    // User closes the screen when it's in sign up mode
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: CLLocationManager Delegate methods and reverse geocoding
extension WalkthroughLocationVC{
    
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
            self.showIndicatorActivity(false)
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
                    self.locationTextField.text = "\(city), \(countryShortName)"
                    setActionButton(true)
                }else{ // Unable to get city and country
                    print("Unable to get city and country")
                    errorGettingLocation()
                }
            }else{ // Placemark is nil
                print("Placemark is nil")
                errorGettingLocation()
            }
        } else {
            print("For some reason location is nil")
        }
        
    }
    
    
}

// MARK: Google API - Reverse Geocoding the list of place IDs from the auto completion
// Google place auto complete ID returns a list of place IDs based on the user input, and we use google geocoding API retrieve city, country information based on that ID
extension WalkthroughLocationVC: GMSAutocompleteFetcherDelegate{
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        tableData.removeAll()
        tableData.append("Use current location")
        print("Predictions count: ", predictions.count)
        
        for prediction in predictions {
            // At this point, we received the auto completion results in the prediction array, and each prediction has a Place ID, and we need to get city/country information from that ID and we use reverse geocoding API to receive JSON of the place's address details
            let yourAPI = ""
            let url = "https://maps.googleapis.com/maps/api/geocode/json?place_id=\(prediction.placeID!)&key=\(yourAPI)"
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
        print(error.localizedDescription)
        if !Reachability.isConnectedToNetwork(){
            isInternetAvailable = false
            suggestionsView.isHidden = true
            locationTextField.resignFirstResponder()
            locationTextField.text = ""
            print("Google API cannot connect to the internet...")
        }
    }
    
}

