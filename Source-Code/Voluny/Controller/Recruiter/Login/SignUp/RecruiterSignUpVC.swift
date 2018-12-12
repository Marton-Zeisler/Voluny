//
//  RecruiterSignUpVC.swift
//  Voluny
//


import UIKit
import Firebase

class RecruiterSignUpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signUpButton: WalkthroughRoundedButton!
    @IBOutlet weak var organisationTextField: UITextField!
    @IBOutlet weak var recruiterTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    var selectedCity:String!
    
    // alerts
    @IBOutlet weak var organisationAlert: UIImageView!
    @IBOutlet weak var recruiterAlert: UIImageView!
    @IBOutlet weak var emailAlert: UIImageView!
    @IBOutlet weak var passAlert: UIImageView!
    @IBOutlet weak var passAgainAlert: UIImageView!
    @IBOutlet weak var phoneAlert: UIImageView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        indicator.isHidden = true
        enableSignInButton(enable: false)
        
        if let getLocation = UserDefaults.standard.string(forKey: "location"){
            selectedCity = getLocation
            locationLabel.text = selectedCity
        }
        
        organisationTextField.delegate = self
        organisationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        recruiterTextField.delegate = self
        recruiterTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        passwordAgainTextField.delegate = self
        passwordAgainTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        phoneTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: Notification.Name("locationChanged"), object: nil)
        
        organisationTextField.attributedPlaceholder = NSAttributedString(string: "Enter name of organization", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16)!])
        
        recruiterTextField.attributedPlaceholder = NSAttributedString(string: "Enter your name", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16)!])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter email address", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16)!])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16)!])
        
        passwordAgainTextField.attributedPlaceholder = NSAttributedString(string: "Enter password again", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16)!])
        
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Enter phone number", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16)!])
        
    }
    
    func  enableSignInButton(enable: Bool){
        if enable{
            signUpButton.isEnabled = true
            signUpButton.alpha = 1.0
        }else{
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.65
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        enableSignInButton(enable: checkingUserInfo())
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField{
            if !emailTextField.text!.isValidEmail(){
                emailAlert.isHidden = false
            }else{
                emailAlert.isHidden = true
            }
        }else if (textField == passwordTextField && passwordAgainTextField.hasText) || (textField == passwordAgainTextField && passwordTextField.hasText){
            if passwordTextField.text! != passwordAgainTextField.text!{
                passAlert.isHidden = false
                passAgainAlert.isHidden = false
            }else{
                passAlert.isHidden = true
                passAgainAlert.isHidden = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case organisationTextField:
            recruiterTextField.becomeFirstResponder()
        case recruiterTextField:
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
    
    
    @objc func locationChanged(_ notification: Notification){
        if let data = notification.object as? String{
            locationLabel.text = data
            selectedCity = data
        }
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        setAlarms()
        if checkingUserInfo() == true{
            indicator.isHidden = false
            indicator.startAnimating()
            enableSignInButton(enable: false)
            signUserUp()
        }else{
            print("Something is not right with the user info")
            signUpButton.isEnabled = true
        }
    }
    
    func checkingUserInfo() -> Bool{
        if (organisationTextField.text?.count)! > 0 && (recruiterTextField.text?.count)! > 0{
            if emailTextField.text!.isValidEmail() {
                if passwordTextField.text == passwordAgainTextField.text && (passwordTextField.text?.count)! >= 6{
                    if (phoneTextField.text?.count)! > 0{
                        if locationLabel.text != "Select a City"{
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func setAlarms(){
        if (organisationTextField.text?.count)! < 1{
            organisationAlert.isHidden = false
        }else{
            organisationAlert.isHidden = true
        }
        
        if (recruiterTextField.text?.count)! < 1{
            recruiterAlert.isHidden = false
        }else{
            recruiterAlert.isHidden = true
        }
        
        if emailTextField.text!.isValidEmail(){
            emailAlert.isHidden = true
        }else{
            emailAlert.isHidden = false
        }
        
        if (passwordTextField.text?.count)! < 6{
            passAlert.isHidden = false
        }else{
            passAlert.isHidden = true
        }
        
        if (passwordTextField.text != passwordAgainTextField.text) || (passwordAgainTextField.text?.count)! < 6{
            passAgainAlert.isHidden = false
        }else{
            passAgainAlert.isHidden = true
        }
        
        if (phoneTextField.text?.count)! < 1{
            phoneAlert.isHidden = false
        }else{
            phoneAlert.isHidden = true
        }
    }
    
    
    
    func signUserUp(){
        var userData = [String: String]()
        userData = ["email": emailTextField.text!, "organization": organisationTextField.text!, "recruiter": recruiterTextField.text!, "phoneNumber": phoneTextField.text!, "userType": "recruiter", "city": locationLabel.text!]
        AuthService.instance.signUpRecruiter(email: emailTextField.text!, password: passwordTextField.text!, userData: userData) { (status, error) in
            if status == true{
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                self.signUpButton.isEnabled = true
                print("Successful sign up")
                self.enableSignInButton(enable: true)
                self.performSegue(withIdentifier: "home", sender: nil)
            }else{
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                self.enableSignInButton(enable: true)
                if let errorPrint = error?.localizedDescription{
                    print(errorPrint)
                    if errorPrint == "The email address is already in use by another account."{
                        self.performSegue(withIdentifier: "retry", sender: "volunteer")
                    }
                }
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "location"{
            let destination = segue.destination as! WalkthroughLocationVC
            destination.isSignUp = true
        }
        
        if segue.identifier == "retry" && sender != nil{
            let destination = segue.destination as! LoginMessage
            destination.message = "The email address is already in use by another account."
        }
    }
    
    
    @IBAction func locationTapped(_ sender: Any) {
        performSegue(withIdentifier: "location", sender: nil)
    }
    
    



}
