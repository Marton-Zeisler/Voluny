//
//  UpdatePassVC.swift
//  Voluny
//


import UIKit
import Firebase

class UpdatePassVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oldPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var verifyPassTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        oldPassTextField.delegate = self
        newPassTextField.delegate = self
        verifyPassTextField.delegate = self
        
        oldPassTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        newPassTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        verifyPassTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        oldPassTextField.attributedPlaceholder = NSAttributedString(string: "Enter your old password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 15)!])
        newPassTextField.attributedPlaceholder = NSAttributedString(string: "Enter your new password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 15)!])
        verifyPassTextField.attributedPlaceholder = NSAttributedString(string: "Verify your new password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 15)!])
        
        enableUpdateButton(false)
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField){
        if oldPassTextField.text!.count >= 6 && newPassTextField.text!.count >= 6 && verifyPassTextField.text!.count >= 6{
            enableUpdateButton(true)
        }else{
            enableUpdateButton(false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPassTextField{
            newPassTextField.becomeFirstResponder()
        }else if textField == newPassTextField{
            verifyPassTextField.becomeFirstResponder()
        }else{
            if newPassTextField.text!.count >= 6 && verifyPassTextField.text!.count >= 6 && oldPassTextField.text!.count >= 6{
                textField.endEditing(true)
                updateTapped(self)
            }else{
                textField.endEditing(true)
            }
        }
        
        return true
    }
    
    func enableUpdateButton(_ enabled: Bool){
        if enabled{
            updateButton.isEnabled = true
            updateButton.alpha = 1.0
        }else{
            updateButton.isEnabled = false
            updateButton.alpha = 0.6
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }

    @IBAction func updateTapped(_ sender: Any){
        if newPassTextField.text! != verifyPassTextField.text!{
            // passwords don't match
            performSegue(withIdentifier: "error", sender: "The passwords you entered do not match. Try again.")
        }else{
            // passwords match
            // Check authorization
            let creditential = EmailAuthProvider.credential(withEmail: Auth.auth().currentUser?.email ?? "", password: oldPassTextField.text!)
            Auth.auth().currentUser?.reauthenticate(with: creditential, completion: { (error) in
                if error == nil{
                    // Authorization successful, now update pass
                    Auth.auth().currentUser?.updatePassword(to: self.newPassTextField.text!, completion: { (error) in
                        if error == nil{
                            // successful
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            // failed
                            self.performSegue(withIdentifier: "error", sender: "There is a problem updating your password")
                        }
                    })
                }else{
                    // Authorization failed, cannot update pass
                    self.performSegue(withIdentifier: "error", sender: "You entered your current password incorrectly")
                }
            })
            

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "error"{
            let errorVC = segue.destination as! LoginMessage
            errorVC.message = sender as! String
            errorVC.buttonText = "Okay"
        }
    }
    
}
