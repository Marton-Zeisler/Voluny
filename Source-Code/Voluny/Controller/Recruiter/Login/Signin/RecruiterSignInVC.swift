//
//  RecruiterSignInVC.swift
//  Voluny
//


import UIKit
import Firebase

class RecruiterSignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        indicatorStart(false)
        signInButton.isEnabled = false
        signInButton.alpha = 0.65
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter email address", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
    }
    
    // MARK: TextField methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else{
            textField.endEditing(true)
            if checkingUserInfo(){
                signIn(self)
            }
        }
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        if checkingUserInfo(){
            signInButton.isEnabled = true
            signInButton.alpha = 1.0
        }else{
            signInButton.isEnabled = false
            signInButton.alpha = 0.65
        }
    }
    
    func indicatorStart(_ start: Bool){
        if start{
            indicator.isHidden = false
            indicator.startAnimating()
            signInButton.isEnabled = false
            signInButton.alpha = 0.65
        }else{
            indicator.isHidden = true
            indicator.stopAnimating()
            signInButton.isEnabled = true
            signInButton.alpha = 1.0
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        if checkingUserInfo() == true{
            indicatorStart(true)
            AuthService.instance.signInUser(email: emailTextField.text!, password: passwordTextField.text!, logincomplete: { (status, error) in
                if status == true{
                    DataService.instance.isUserVolunteer(uid: (Auth.auth().currentUser?.uid)!, handler: { (isVolunteer) in
                        if isVolunteer == true{
                            self.indicatorStart(false)
                            self.performSegue(withIdentifier: "retry", sender: "volunteer")
                            print("this is a volunteer account")
                        }else{
                            self.indicatorStart(false)
                            print("Successfully signed in recruiter")
                            self.performSegue(withIdentifier: "home", sender: nil)
                        }
                    })
   
                }else if status == false || error != nil{
                    self.indicatorStart(false)
                    print("Sign in error: ", String(describing: error?.localizedDescription))
                    self.performSegue(withIdentifier: "retry", sender: nil)
                }
            })
        }else{
            self.performSegue(withIdentifier: "retry", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "retry" && sender != nil{
            let destination = segue.destination as! LoginMessage
            destination.message = "This email address is associated with a volunteer account."
        }
    }
    
    func checkingUserInfo() -> Bool{
        if emailTextField.text!.isValidEmail() && (passwordTextField.text?.count)! >= 6 {
            return true
        }
        return false
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        performSegue(withIdentifier: "reset", sender: nil)
    }
    
    
    


    



}
