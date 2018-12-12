//
//  SignUpVC.swift
//  Voluny
//


import UIKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var signUpButton: WalkthroughRoundedButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var selectedDate:String?
    
    var imagePicker: UIImagePickerController!
    
    var selectedCity:String!
    
    var selectedAgeGroup: String!

    @IBOutlet weak var locationLabel: UILabel!
    
    // Alerts
    @IBOutlet weak var firstNameAlert: UIImageView!
    @IBOutlet weak var lastNameAlert: UIImageView!
    @IBOutlet weak var emailAlert: UIImageView!
    @IBOutlet weak var passwordAlert: UIImageView!
    @IBOutlet weak var passwordAgainAlert: UIImageView!
    @IBOutlet weak var dateAlert: UIImageView!
    @IBOutlet weak var phoneAlert: UIImageView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(dateAdded), name: Notification.Name("dateAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: Notification.Name("locationChanged"), object: nil)
        
        self.hideKeyboardWhenTappedAround()
        
        if let getLocation = UserDefaults.standard.string(forKey: "location"){
            selectedCity = getLocation
            locationLabel.text = selectedCity
        }

        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = true
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "Enter first name", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Enter last name", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter email address", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
        passwordAgainTextField.attributedPlaceholder = NSAttributedString(string: "Enter password again", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Enter phone number", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordAgainTextField.becomeFirstResponder()
        case passwordAgainTextField:
            phoneTextField.becomeFirstResponder()
        default:
            textField.endEditing(true)
        }
        
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage{
            profileImage.image = image
            
        }else{
            print("Marton: A valid image wasn't selected")
        }
        
        
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @objc func locationChanged(_ notification: Notification){
        if let data = notification.object as? String{
            locationLabel.text = data
            selectedCity = data
        }
    }
    
    @objc func dateAdded(_ notification: Notification){
        if let data = notification.object as? String{
            selectedDate = data
            dateButton.setTitle(data, for: .normal)
            dateButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 20)
            dateButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @IBAction func dateTapped(_ sender: Any) {
        performSegue(withIdentifier: "datePop", sender: nil)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        signUpButton.isEnabled = false
        setAlerts()
        if checkingUserInfo() == true{
            indicator.isHidden = false
            indicator.startAnimating()
            determineAgeGroup()
            signUserUp()
        }else{
            print("Something is not right with the user info")
            signUpButton.isEnabled = true
        }
    }
    
    func checkingUserInfo() -> Bool{
        if (firstNameTextField.text?.count)! > 0 && (lastNameTextField.text?.count)! > 0{
            if emailTextField.text!.isValidEmail(){
                if passwordTextField.text == passwordAgainTextField.text && (passwordTextField.text?.count)! >= 6{
                    if dateButton.titleLabel?.text != "DD/MM/YYYY"{
                        if (phoneTextField.text?.count)! > 0{
                            return true
                        }
                    }
                }
        }
    }
        return false
    }
    
    func setAlerts(){
        if (firstNameTextField.text?.count)! < 1{
            firstNameAlert.isHidden = false
        }else{
            firstNameAlert.isHidden = true
        }
        
        if (lastNameTextField.text?.count)! < 1{
            lastNameAlert.isHidden = false
        }else{
            lastNameAlert.isHidden = true
        }
        
        if emailTextField.text!.isValidEmail() == false{
            emailAlert.isHidden = false
        }else{
            emailAlert.isHidden = true
        }
        
        if (passwordTextField.text?.count)! < 6{
            passwordAlert.isHidden = false
        }else{
            passwordAlert.isHidden = true
        }
        
        if passwordTextField.text != passwordAgainTextField.text{
            passwordAgainAlert.isHidden = false
        }else{
            passwordAgainAlert.isHidden = true
        }
        
        if (passwordAgainTextField.text?.count)! < 6{
            passwordAgainAlert.isHidden = false
        }
        
        if dateButton.titleLabel?.text == "DD/MM/YYYY"{
            dateAlert.isHidden = false
        }else{
            dateAlert.isHidden = true
        }
        
        if (phoneTextField.text?.count)! < 1{
            phoneAlert.isHidden = false
        }else{
            phoneAlert.isHidden = true
        }
        
        
        
        
    }
    
    func determineAgeGroup(){
        // DON'T FORGET THIS
    }
    
    func signUserUp(){
        print("signing up...")
        let fullName = "\(firstNameTextField.text!) \(lastNameTextField.text!)"
        var userData = [String: String]()
        userData =  ["email":emailTextField.text!, "fullName": fullName, "DOB": (dateButton.titleLabel?.text)!, "phoneNumber": phoneTextField.text!, "city": selectedCity, "userType": "volunteer"]
        AuthService.instance.signUpUser(email: emailTextField.text!, password: passwordTextField.text!, userData: userData, userImage: profileImage.image!) { (status, error) in
            if status == true{
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                print("Successful sign up")
                self.signUpButton.isEnabled = true
                NotificationCenter.default.post(name: Notification.Name("userLoggedIn"), object: false)
                self.dismiss(animated: true, completion: nil)
                //NotificationCenter.default.post(name: Notification.Name("loginClosed"), object: nil)
            }else{
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                self.signUpButton.isEnabled = true
                if let errorPrint = error?.localizedDescription{
                    print(errorPrint)
                    if errorPrint == "The email address is already in use by another account."{
                        self.performSegue(withIdentifier: "retry", sender: "volunteer")
                    }
                }
            }
        }
        
    }
    
    @IBAction func locationTapped(_ sender: Any) {
        performSegue(withIdentifier: "location", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "location"{
            let destination = segue.destination as! WalkthroughLocationVC
            destination.isSignUp = true
        }
        
        if segue.identifier == "datePop"{
            let destination = segue.destination as! DateSelectionVC
            if dateButton.currentTitle != "DD/MM/YYYY"{
                destination.selectedDate = dateButton.currentTitle!
            }
        }
        
        if segue.identifier == "retry" && sender != nil{
            let destination = segue.destination as! LoginMessage
            destination.message = "The email address is already in use by another account."
        }
        
        
    }
    
    
    

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
