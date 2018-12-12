//
//  HomeVC.swift
//  Voluny
//


import UIKit
import Firebase

class HomeVC: UIViewController, UITextFieldDelegate, CitySearchProtocol, NoCityFoundProtocol, ExperienceSearchProtocol {

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var status1View: UIView!
    @IBOutlet weak var status1Image: UIImageView!
    @IBOutlet weak var status1Title: UILabel!
    @IBOutlet weak var status1ExperienceLabel: UILabel!
    
    
    @IBOutlet weak var status2View: UIView!
    @IBOutlet weak var status2Image: UIImageView!
    @IBOutlet weak var status2Title: UILabel!
    @IBOutlet weak var status2ExperienceLabel: UILabel!

    
    @IBOutlet weak var status3View: UIView!
    @IBOutlet weak var status3Image: UIImageView!
    @IBOutlet weak var status3Title: UILabel!
    @IBOutlet weak var status3ExperienceLabel: UILabel!

    @IBOutlet weak var trendingTableview: UITableView!
    @IBOutlet weak var seeAllButton: UIButton!
    
    var experiences = [Experience]()
    var isUserAppliedSelectedExperience = false
    
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var reusableExperienceTable: ReusableExperienceTableView!
    @IBOutlet weak var citySearchTableView: UITableView!
    var reusableCitySearchTable: ReusabeCitySearchTableView!
    @IBOutlet weak var suggestionsView: WalkthroughShadowView!
    @IBOutlet weak var suggestionBackgroundView: UIView!
    @IBOutlet weak var unavailableView: NoCityFoundView!
    
    // Indicator Views
    var indicatorBackground: UIView!
    var suggestionsActivityIndicator: UIActivityIndicatorView!
    var isInternetAvailable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide keyboard and suggestions view when tapped away
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        locationTextField.modifyClearButton(with: UIImage(named: "Button: Cancel.png")!)
        
        locationTextField.delegate = self
        
        setupIndicatorViews() // Setting up the activity indicator view and its background view
        
        reusableCitySearchTable = ReusabeCitySearchTableView(tableView: citySearchTableView)
        reusableCitySearchTable.citySearchProtocol = self
        
        unavailableView.noCityFoundProtocol = self
            
        self.hideKeyboardWhenTappedAround()
        
        reusableExperienceTable = ReusableExperienceTableView(tableView: trendingTableview)
        reusableExperienceTable.experienceSearchProtocol = self
        
        statusIndicator.startAnimating()
        seeAllButton.addTarget(self, action: #selector(self.seeAllTapped(_:)), for: .touchUpInside)
        if let currentEmail = Auth.auth().currentUser?.email{
            print("Current user's email: ", currentEmail)
        }
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        trendingTableview.isUserInteractionEnabled = true
        //self.hidesBottomBarWhenPushed = false
        
        if let getLocation = UserDefaults.standard.string(forKey: "location"){
            locationTextField.text = getLocation
        }
        
        
        if locationTextField.hasText{
            locationTextField.rightViewMode = .always
            activityIndicator.startAnimating()
            loadExperiences()
            
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
        
        let x = Double(UIScreen.main.bounds.width / 5.0 )
        //let y = Double(UIScreen.main.bounds.height * 0.123) //Double(UIScreen.main.bounds.height * 0.08831521739)
        var y = 0.0
        
        if UIScreen.main.bounds.height == 667{ // iphone 8
            y = 65.0
        }else if UIScreen.main.bounds.height >= 812{ // iphone x
            y = 100.0
        }else if UIScreen.main.bounds.height == 736{
            y = 65.0
        }else if UIScreen.main.bounds.height == 568{
            y = 55.0
        }else{
            y = 65.0
        }
        
        // Setting the background color of tab bar
        let color = UIColor(red:0.61, green:0.17, blue:0.38, alpha:1.0)
        let indicatorBackground: UIImage? = imageSet(from: color, for: CGSize(width: x, height: y))
        let tabBarImg = UIImage(named: "tabBarImage")?.resizeImage(CGSize(width: x, height: y))
        self.tabBarController?.tabBar.selectionIndicatorImage =  tabBarImg
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trendingTableview.isUserInteractionEnabled = true
    }
    
    
    func imageSet(from color: UIColor, for size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        autoreleasepool {
            UIGraphicsBeginImageContext(rect.size)
        }
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser?.isAnonymous == false{
            loadStatuses()
        }else{
            statusIndicator.stopAnimating()
            statusIndicator.isHidden = true
            loadStatusesAnon()
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
    
    @objc func seeAllTapped(_ sender : UIButton!) {
        self.tabBarController?.selectedIndex = 2
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
        //reusableExperienceTable.tableView.layoutIfNeeded()
        //reusableExperienceTable.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        //trendingTableview.layoutIfNeeded()
        //trendingTableview.setContentOffset(CGPoint(x: 0, y: -trendingTableview.contentInset.top), animated: true)
    }
    
    func loadExperiences(){
        DataService.instance.getExperiencesForCity(userCity: locationTextField.text!) { (returnedExperiences) in
            self.reusableExperienceTable.loadData(experiences: returnedExperiences.reversed())
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

        do{
            try Auth.auth().signOut()
            let firstVC = storyboard?.instantiateViewController(withIdentifier: "start")
            DispatchQueue.main.async {
                self.present(firstVC!, animated: false, completion: nil)
            }
            print("Firebase: Successfully signed out!")
        }catch let signOutError as NSError{
            print("Error signing out: \(signOutError)")
        }
        
    }
    
    func experienceTapped(experienceID: String, indexPath: IndexPath) {
        self.hidesBottomBarWhenPushed = true
        trendingTableview.isUserInteractionEnabled = false
        self.hidesBottomBarWhenPushed = true
        
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
extension HomeVC{
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





extension UIImage {
    func resizeImage(_ newSize: CGSize) -> UIImage? {
        func isSameSize(_ newSize: CGSize) -> Bool {
            return size == newSize
        }
        
        func scaleImage(_ newSize: CGSize) -> UIImage? {
            func getScaledRect(_ newSize: CGSize) -> CGRect {
                let ratio   = max(newSize.width / size.width, newSize.height / size.height)
                let width   = newSize.width//size.width * ratio
                let height  = newSize.height//size.height * ratio
                return CGRect(x: 0, y: 0, width: width, height: height)
            }
            
            func _scaleImage(_ scaledRect: CGRect) -> UIImage? {
                UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
                draw(in: scaledRect)
                let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                UIGraphicsEndImageContext()
                return image
            }
            return _scaleImage(getScaledRect(newSize))
        }
        
        print(isSameSize(newSize))
        return isSameSize(newSize) ? self : scaleImage(newSize)!
    }
}
