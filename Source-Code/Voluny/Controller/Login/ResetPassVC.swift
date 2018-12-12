//
//  ResetPassVC.swift
//  Voluny
//


import UIKit
import Firebase

class ResetPassVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        indicatorStart(false)
        resetButton.isEnabled = false
        resetButton.alpha = 0.65
        
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter email address", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
        NotificationCenter.default.addObserver(self, selector: #selector(successReset), name: Notification.Name("successReset"), object: nil)

    }
    
    @objc func textFieldDidChange(textField: UITextField){
        if textField.text!.isValidEmail(){
            resetButton.isEnabled = true
            resetButton.alpha = 1.0
        }else{
            resetButton.isEnabled = false
            resetButton.alpha = 0.65
        }
    }
    
    func indicatorStart(_ start: Bool){
        if start{
            indicator.isHidden = false
            indicator.startAnimating()
            resetButton.isEnabled = false
            resetButton.alpha = 0.65
        }else{
            indicator.isHidden = true
            indicator.stopAnimating()
            resetButton.isEnabled = true
            resetButton.alpha = 1.0
        }
    }
    
    @objc func successReset(_ notification: Notification){
        self.navigationController?.popViewController(animated: true)
    }
    
    

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isValidEmail(){
            resetTapped(true)
        }else{
            textField.endEditing(true)
        }
        
        return true
    }

    @IBAction func resetTapped(_ sender: Any) {
        indicatorStart(true)
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error == nil{
                print("Success")
                self.indicatorStart(false)
                self.performSegue(withIdentifier: "message", sender: true)
            }else{
                self.indicatorStart(false)
                print(error!)
                self.performSegue(withIdentifier: "message", sender: false)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "message"{
            let destination = segue.destination as! LoginMessage
            if sender as! Bool == true{
                destination.message =  "Thank you! A link to reset your password has been sent to your email."
                destination.buttonText = "CLOSE"
                destination.isResetMode = true
            }else{
                destination.message =  "We’re sorry! The email you entered does not exist. Please try again"
                destination.buttonText = "RETRY"
            }
        }
    }
    

}
