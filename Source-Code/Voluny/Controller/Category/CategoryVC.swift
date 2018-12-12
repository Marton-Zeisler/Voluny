//
//  CategoryVC.swift
//  Voluny
//


import UIKit

class CategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CitySearchProtocol, UITextFieldDelegate, NoCityFoundProtocol {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    let categoryNames = ["ANIMAL", "CHILDREN", "COMMUNITY", "DISABILITY", "EDUCATION", "ENVIRONMENT", "HEALTH", "HOMELESS", "SENIOR"]
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var citySearchTableView: UITableView!
    var reusableCitySearchTable: ReusabeCitySearchTableView!
    @IBOutlet weak var suggestionsView: WalkthroughShadowView!
    
    // Indicator Views
    var indicatorBackground: UIView!
    var activityIndicator: UIActivityIndicatorView!
    var isInternetAvailable = true
    @IBOutlet weak var suggestionBackgroundView: UIView!
    
    @IBOutlet weak var unavailableView: NoCityFoundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide keyboard and suggestions view when tapped away
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        //locationTextField.modifyClearButton(with: UIImage(named: "Button: Cancel.png")!) // Setting a custom clear button for the text field
        locationTextField.modifyClearButton(with: UIImage(named: "Button: Cancel.png")!)
        
        locationTextField.delegate = self
        setupIndicatorViews() // Setting up the activity indicator view and its background view
        
        reusableCitySearchTable = ReusabeCitySearchTableView(tableView: citySearchTableView)
        reusableCitySearchTable.citySearchProtocol = self
        
        unavailableView.noCityFoundProtocol = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if let getLocation = UserDefaults.standard.string(forKey: "location"){
            locationTextField.text = getLocation
        }
        
        if locationTextField.hasText{
            locationTextField.rightViewMode = .always
            
            DataService.instance.isCityActive(city: locationTextField.text!) { (active) in
                if active{
                    self.unavailableView.isHidden = true
                    self.locationTextField.rightViewMode = .always
                }else{
                    self.locationTextField.text = ""
                    self.locationTextField.rightViewMode = .whileEditing
                    if self.unavailableView.isHidden{
                        self.unavailableView.isHidden = false
                        self.loadNoCities()
                    }
                }
            }
            
        }else{
            locationTextField.rightViewMode = .whileEditing
            if self.unavailableView.isHidden{
                self.unavailableView.isHidden = false
                self.loadNoCities()
            }
        }
        

        
    }
    
    func loadNoCities(){
        DataService.instance.supportedCities { (cities) in
            self.unavailableView.loadData(data: cities)
        }
    }
    
    @objc override func dismissKeyboard() {
        suggestionViewShow(show: false)
        view.endEditing(true)
    }
    
    // MARK: Managing the Activity Indicator
    func setupIndicatorViews(){
        indicatorBackground = UIView(frame: view.bounds)
        indicatorBackground.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.203537632)
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x-18, y: view.center.y-18, width: 36, height: 36))
        activityIndicator.style = .whiteLarge
        indicatorBackground.addSubview(activityIndicator)
    }
    
    // MARK: TextField Delegate Methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        if locationTextField.text == ""{
            locationTextField.rightViewMode = .whileEditing
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
            reusableCitySearchTable.fetcher?.sourceTextHasChanged(locationTextField.text!) // Updating the auto completion results
        }
        
        if locationTextField.text == ""{
            suggestionViewShow(show: false)
            if unavailableView.isHidden{
                unavailableView.isHidden = false
                loadNoCities()
            }
        }else{
            suggestionViewShow(show: true)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCell
        cell.titleLabel.text = categoryNames[indexPath.row]
        cell.iconImageView.image = UIImage(named: "\(categoryNames[indexPath.row])_i.png")
        
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 4.0
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 28 - 28 - 10 - 10) / 2
        return CGSize(width: width, height: UIScreen.main.bounds.height * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toTappedCategory", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTappedCategory"{
            let destinationVC = segue.destination as! TappedCategoryVC
            let index = sender as! Int
            destinationVC.selectedCategory = categoryNames[index]
        }
    }

    func didReceiveCity(city: String) {
        categoryCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        locationTextField.text = city
        UserDefaults.standard.set(city, forKey: "location")
        unavailableView.isHidden = true
        locationTextField.rightViewMode = .always
    }

}

// Conforming to the CitySearchProtocol
extension CategoryVC{
    func locationDenied() {
        let alertVC = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    

    func showInidicatorAcitivity(show: Bool) {
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
    
    func errorGettingLocation() {
        showInidicatorAcitivity(show: false)
        locationTextField.text = ""
        locationTextField.rightViewMode = .whileEditing
        let alertVC = UIAlertController(title: "Unable to access your location", message: "Please search for a city manually by typing", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func suggestionViewShow(show: Bool) {
        if show{
            suggestionsView.isHidden = false
            suggestionBackgroundView.isHidden = false
        }else{
            suggestionsView.isHidden = true
            suggestionBackgroundView.isHidden = true
        }
    }
    
    func textFieldDidRecieveCity(text: String) {
        DataService.instance.isCityActive(city: text) { (active) in
            if active{
                self.locationTextField.text = text
                UserDefaults.standard.set(text, forKey: "location")
                self.unavailableView.isHidden = true
                self.locationTextField.rightViewMode = .always
            }else{
                self.locationTextField.text = ""
                self.locationTextField.rightViewMode = .whileEditing
                if self.unavailableView.isHidden{
                    self.unavailableView.isHidden = false
                    self.loadNoCities()
                }
            }
        }

    }
    
    func didFailAutoComplete(error: Error) {
        print(error.localizedDescription)
        if !Reachability.isConnectedToNetwork(){
            isInternetAvailable = false
            suggestionViewShow(show: false)
            locationTextField.resignFirstResponder()
            locationTextField.text = ""
            locationTextField.rightViewMode = .whileEditing
            print("Google API cannot connect to the internet...")
        }
    }
}
