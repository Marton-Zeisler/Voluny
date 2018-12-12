//
//  TappedCategoryVC.swift
//  Voluny
//


import UIKit
import Firebase

class TappedCategoryVC: UIViewController, UITextFieldDelegate, CitySearchProtocol, NoCityFoundProtocol, ExperienceSearchProtocol {

    @IBOutlet weak var categoryTtitleLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedCategory:String!
    
    var isUserAppliedSelectedExperience = false

    var experiences = [Experience]()
    var reusableTable: ReusableExperienceTableView!
    
    @IBOutlet weak var citySearchTableView: UITableView!
    var reusableCitySearchTable: ReusabeCitySearchTableView!
    @IBOutlet weak var suggestionsView: WalkthroughShadowView!
    
    // Indicator Views
    var indicatorBackground: UIView!
    var suggestionsActivityIndicator: UIActivityIndicatorView!
    var isInternetAvailable = true
    @IBOutlet weak var suggestionBackgroundView: UIView!
    
    @IBOutlet weak var unavailableView: NoCityFoundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide keyboard and suggestions view when tapped away
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //locationTextField.modifyClearButton(with: UIImage(named: "Button: Cancel.png")!) // Setting a custom clear button for the text field
        locationTextField.modifyClearButton(with: UIImage(named: "Button: Cancel.png")!)
        
        
        if let getLocation = UserDefaults.standard.string(forKey: "location"){
            locationTextField.text = getLocation
        }
        
        if locationTextField.hasText{
            locationTextField.rightViewMode = .always
        }else{
            locationTextField.rightViewMode = .whileEditing
        }
        
        locationTextField.delegate = self
        setupIndicatorViews() // Setting up the activity indicator view and its background view
        
        reusableCitySearchTable = ReusabeCitySearchTableView(tableView: citySearchTableView)
        reusableCitySearchTable.citySearchProtocol = self
        
        unavailableView.noCityFoundProtocol = self
        
        // Experience section
        if locationTextField.hasText{
            activityIndicator.startAnimating()
            loadExperiences()
        }else{
            unavailableView.isHidden = false
        }
        
        locationTextField.delegate = self
        
        if let getLocation = UserDefaults.standard.string(forKey: "location"){
            locationTextField.text = getLocation
        }
        
        self.hideKeyboardWhenTappedAround()
        
        categoryLabel.text = selectedCategory
        categoryTtitleLabel.text = "CATEGORY: \(selectedCategory!)"
        bannerImageView.image = UIImage(named: "\(selectedCategory!).png")
        
        locationTextField.modifyClearButton(with: UIImage(named: "Button: Cancel.png")!)
        
        reusableTable = ReusableExperienceTableView(tableView: tableview)
        reusableTable.experienceSearchProtocol = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.isUserInteractionEnabled = true
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
        suggestionsActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x-18, y: view.center.y-18, width: 36, height: 36))
        suggestionsActivityIndicator.style = .whiteLarge
        indicatorBackground.addSubview(suggestionsActivityIndicator)
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
    
    func didReceiveCity(city: String) {
        locationTextField.text = city
        UserDefaults.standard.set(city, forKey: "location")
        unavailableView.isHidden = true
        locationTextField.rightViewMode = .always
        loadExperiences()
    }
    
    func loadExperiences(){
        DataService.instance.getExperiencesFromCategory(userCity: locationTextField.text!, category: selectedCategory) { (returnedExperiences) in
            self.reusableTable.loadData(experiences: returnedExperiences.reversed())
            self.experiences = returnedExperiences.reversed()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOpenedExperienceVC" {
            let destination = segue.destination as! OpenedExperienceVC
            destination.selectedExperience = experiences[sender as! Int]
            destination.isApplied = isUserAppliedSelectedExperience
        }
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func experienceTapped(experienceID: String, indexPath: IndexPath) {
        self.hidesBottomBarWhenPushed = true
        tableview.isUserInteractionEnabled = false
        
        if Auth.auth().currentUser?.isAnonymous == false{
            DataService.instance.didUserApply(experienceID: experienceID, userID: (Auth.auth().currentUser?.uid)!) { (applied) in
                self.isUserAppliedSelectedExperience = applied
                self.performSegue(withIdentifier: "toOpenedExperienceVC", sender: indexPath.row)
                self.hidesBottomBarWhenPushed = false
            }
        }else{
            performSegue(withIdentifier: "toOpenedExperienceVC", sender: indexPath.row)
            self.hidesBottomBarWhenPushed = false
        }
    }

}

// Conforming to the CitySearchProtocol
extension TappedCategoryVC{
    func locationDenied() {
        let alertVC = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
    func showInidicatorAcitivity(show: Bool) {
        if show{
            view.addSubview(indicatorBackground)
            suggestionsActivityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        }else{ // remove the indicator
            indicatorBackground.removeFromSuperview()
            suggestionsActivityIndicator.stopAnimating()
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


