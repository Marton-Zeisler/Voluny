//
//  EditProfileVC.swift
//  Voluny
//


import UIKit
import SDWebImage
import Firebase

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var lastTextField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    
    var selectedUser: Volunteer!
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var firstNameAlert: UIImageView!
    @IBOutlet weak var lastNameAlert: UIImageView!
    @IBOutlet weak var phoneAlert: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(dateAdded), name: Notification.Name("dateAdded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: Notification.Name("locationChanged"), object: nil)
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;

        let names = selectedUser.name.split(separator: " ")
        firstTextField.text = String(names[0])
        lastTextField.text = String(names[1])
        dateButton.setTitle(selectedUser.date, for: .normal)
        phoneTextField.text = selectedUser.phone
        locationLabel.text = selectedUser.city
        profileImage.sd_setImage(with: URL(string: selectedUser.profileURL))
        
        firstTextField.attributedPlaceholder = NSAttributedString(string: "Enter first name", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
         lastTextField.attributedPlaceholder = NSAttributedString(string: "Enter last name", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])
        
         phoneTextField.attributedPlaceholder = NSAttributedString(string: "Enter your phone number", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 20)!])

    }
    
    @objc func dateAdded(_ notification: Notification){
        if let data = notification.object as? String{
            dateButton.setTitle(data, for: .normal)
        }
    }
    
    @objc func locationChanged(_ notification: Notification){
        if let data = notification.object as? String{
            locationLabel.text = data
        }
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
    

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        setAlerts()
        if checkingUserInfo() == true{
            updateUserInfo()
            self.navigationController?.popViewController(animated: true)
        }else{
            print("Something is not right with the user info")
        }
    }
    
    func checkingUserInfo() ->Bool{
        if (firstTextField.text?.count)! > 0 && (lastTextField.text?.count)! > 0{
            if dateButton.titleLabel?.text != "MM/DD/YYYY"{
                if (phoneTextField.text?.count)! > 0{
                    return true
                }
            }
        }
        return false
    }
    
    func setAlerts(){
        if (firstTextField.text?.count)! < 1{
            firstNameAlert.isHidden = false
        }else{
            firstNameAlert.isHidden = true
        }
        
        if (lastTextField.text?.count)! < 1{
            lastNameAlert.isHidden = false
        }else{
            lastNameAlert.isHidden = true
        }
        
        if (phoneTextField.text?.count)! < 1{
            phoneAlert.isHidden = false
        }else{
            phoneAlert.isHidden = true
        }
        
        
    }
    
    func updateUserInfo(){
        var userData = [String: String]()
        let fullName = "\(firstTextField.text!) \(lastTextField.text!)"
        userData = ["fullName": fullName, "DOB": (dateButton.titleLabel?.text)!, "phoneNumber": phoneTextField.text!, "city": locationLabel.text!]
        DataService.instance.updateUserInfo(uid: (Auth.auth().currentUser?.uid)!, userData: userData, userImage: profileImage.image!)
        
    }
    
    @IBAction func locationTapped(_ sender: Any) {
        performSegue(withIdentifier: "location", sender: nil)
    }
    
    @IBAction func dateTapped(_ sender: Any) {
        performSegue(withIdentifier: "date", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "location"{
            let destination = segue.destination as! WalkthroughLocationVC
            destination.isSignUp = true
        }
        
        if segue.identifier == "date"{
            let destination = segue.destination as! DateSelectionVC
            destination.selectedDate = dateButton.currentTitle!
        }
        
        if segue.identifier == "error"{
            let destination = segue.destination as! LoginMessage
            destination.message = "All fields are required to be fllled out and an image needs to be selected!"
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
