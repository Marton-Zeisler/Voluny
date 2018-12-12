//
//  RecruitEditProfileVC.swift
//  Voluny
//


import UIKit
import Firebase

class RecruitEditProfileVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var organisationTextField: UITextField!
    @IBOutlet weak var recruiterTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var selectedUser: Recruiter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        enableButton(checkInfo())

        organisationTextField.text = selectedUser.organisation
        organisationTextField.delegate = self
        organisationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        recruiterTextField.text = selectedUser.recruiter
        recruiterTextField.delegate = self
        recruiterTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        phoneTextField.text = selectedUser.phoneNumber
        phoneTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        locationLabel.text = selectedUser.city
        
        organisationTextField.attributedPlaceholder = NSAttributedString(string: "Enter organization", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
        recruiterTextField.attributedPlaceholder = NSAttributedString(string: "Enter Recruiter's name", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])

        phoneTextField.attributedPlaceholder = NSAttributedString(string: "xxx-xxx-xxx", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: Notification.Name("locationChanged"), object: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        enableButton(checkInfo())
    }
    
    func enableButton(_ enabled: Bool){
        if enabled{
            saveButton.isEnabled = true
            saveButton.alpha = 1.0
        }else{
            saveButton.isEnabled = false
            saveButton.alpha = 0.65
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == organisationTextField{
            recruiterTextField.becomeFirstResponder()
        }else if textField == recruiterTextField{
            phoneTextField.becomeFirstResponder()
        }else{
            textField.endEditing(true)
        }
        
        return true
    }
    
    @objc func locationChanged(_ notification: Notification){
        if let data = notification.object as? String{
            locationLabel.text = data
        }
    }

    @IBAction func locationTapped(_ sender: Any) {
        performSegue(withIdentifier: "location", sender: nil)
    }
    
    func checkInfo() ->Bool{
        if (organisationTextField.text?.count)! >= 1{
            if (recruiterTextField.text?.count)! >= 1{
                if (phoneTextField.text?.count)! >= 1{
                    return true
                }
            }
        }
        return false
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func saveTapped(_ sender: Any) {
        if checkInfo() == true{
            enableButton(false)
            var userData = Dictionary<String, Any>()
            userData["organization"] = organisationTextField.text
            userData["recruiter"] = recruiterTextField.text
            userData["phoneNumber"] = phoneTextField.text
            userData["city"] = locationLabel.text
            DataService.instance.updateRecruiterInfo(userID: (Auth.auth().currentUser?.uid)!, userData: userData)
            enableButton(true)
            self.navigationController?.popViewController(animated: true)
        }else{
            performSegue(withIdentifier: "error", sender: nil)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "location"{
            let destination = segue.destination as! WalkthroughLocationVC
            destination.isSignUp = true
        }
        
        if segue.identifier == "error"{
            let destination = segue.destination as! LoginMessage
            destination.message = "All fields are required to be filled out!"
        }
    }
    

}
