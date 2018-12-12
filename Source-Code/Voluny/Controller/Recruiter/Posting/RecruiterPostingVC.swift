//
//  RecruiterPostingVC.swift
//  Voluny
//


import UIKit
import Firebase
import SDWebImage

class RecruiterPostingVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var submitButton: WalkthroughRoundedButton!
    
    //TextFields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    //Images
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    
    //Buttons
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ageGroupLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    var pickerTypeisProfile = true

    var isPickerCategory: Bool!

    var isPosting = true
    var editingExperience: RecruiterActiveExperience!
    var oldCategory = ""
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        oldCategory = categoryLabel.text!
        indicator.isHidden = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        bannerImage.layer.cornerRadius = 8
        
        if let getLocation = UserDefaults.standard.string(forKey: "location"){
            cityLabel.text = getLocation
        }
        
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Enter name of the experience", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 15)!])
        
        addressTextField.attributedPlaceholder = NSAttributedString(string: "Enter address of location", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 15)!])
        
        nameTextField.delegate = self
        addressTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDate), name: Notification.Name("setDate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setCategory), name: Notification.Name("setCategory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setAge), name: Notification.Name("setAge"), object: nil)
        
       NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: Notification.Name("locationChanged"), object: nil)
        
        if isPosting == false{
            nameTextField.text = editingExperience.title
            categoryLabel.text = editingExperience.category
            ageGroupLabel.text = editingExperience.age
            timeButton.setTitle(editingExperience.time, for: .normal)
            dateButton.setTitle(editingExperience.date, for: .normal)
            addressTextField.text = editingExperience.location
            cityLabel.text = editingExperience.city
            descriptionTextView.text = editingExperience.description
            profileImage.sd_setImage(with: URL(string: editingExperience.imageURL))
            bannerImage.sd_setImage(with: URL(string: editingExperience.bannerPhotoURL))
            dateButton.titleLabel?.font = UIFont(name: "Comfortaa-bold", size: 15)
            dateButton.setTitleColor(UIColor.white, for: .normal)
            timeButton.titleLabel?.font = UIFont(name: "Comfortaa-bold", size: 15)
            timeButton.setTitleColor(UIColor.white, for: .normal)
            closeButton.isHidden = false
        }
        
    }
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func locationChanged(_ notification: Notification){
        if let data = notification.object as? String{
            cityLabel.text = data
        }
    }
    
    @objc func setCategory(_ notification: Notification){
        if let data = notification.object as? String{
            categoryLabel.text = data
        }
    }
    
    @objc func setAge(_ notification: Notification){
        if let data = notification.object as? String{
            ageGroupLabel.text = data
        }
    }
    
    
    @objc func setDate(_ notification: Notification){
        if let data = notification.object as? String{
            let date = data.components(separatedBy: " ")
            dateButton.setTitle(date[0], for: .normal)
            timeButton.setTitle(date[1], for: .normal)
            dateButton.titleLabel?.font = UIFont(name: "Comfortaa-bold", size: 15)
            dateButton.setTitleColor(UIColor.white, for: .normal)
            timeButton.titleLabel?.font = UIFont(name: "Comfortaa-bold", size: 15)
            timeButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func categoryTapped(_ sender: Any) {
        view.endEditing(true)
        isPickerCategory = true
        oldCategory = categoryLabel.text!
        performSegue(withIdentifier: "category", sender: nil)
    }
    
    @IBAction func ageGroupTapped(_ sender: Any) {
        view.endEditing(true)
        isPickerCategory = false
        performSegue(withIdentifier: "category", sender: nil)
    }
    
    
    @IBAction func cityTapped(_ sender: Any) {
        performSegue(withIdentifier: "location", sender: nil)
    }
    
    @IBAction func timeTapped(_ sender: Any) {
        performSegue(withIdentifier: "date", sender: nil)
    }
    
    @IBAction func dateTapped(_ sender: Any) {
        performSegue(withIdentifier: "date", sender: nil)
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        pickerTypeisProfile = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func bannerTapped(_ sender: Any) {
        pickerTypeisProfile = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        submitButton.isEnabled = false
        if checkForm() == true{
            indicator.isHidden = false
            indicator.startAnimating()
            var userData = Dictionary<String, Any>()
            userData["ageGroup"] = ageGroupLabel.text!
            userData["category"] = categoryLabel.text!
            userData["city"] = cityLabel.text!
            userData["date"] = dateButton.currentTitle!
            userData["time"] = timeButton.currentTitle!
            userData["longDescription"] = descriptionTextView.text
            userData["preciseLocation"] = addressTextField.text!
            if isPosting ==  true{
                userData["rating"] = 0
            }
            userData["shortDescription"] = descriptionTextView.text
            userData["title"] = nameTextField.text!
            userData["recruiter"] = (Auth.auth().currentUser?.uid)!
            
            if isPosting == true{
                DataService.instance.createExperience(uid: (Auth.auth().currentUser?.uid)!, userData: userData, iconImage: profileImage.image!, bannerImage: bannerImage.image!, handler: { (success) in
                    self.nameTextField.text = ""
                    self.categoryLabel.text = "Select Category"
                    self.ageGroupLabel.text = "Select Age Group"
                    self.timeButton.setTitle("HH:MM", for: .normal)
                    self.dateButton.setTitle("DD/MM/YYYY", for: .normal)
                    self.addressTextField.text = ""
                    self.descriptionTextView.text = ""
                    self.profileImage.image = UIImage(named: "profileDefault")
                    self.bannerImage.image = UIImage(named: "bannerDefault")
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true
                    self.dateButton.titleLabel?.font = UIFont(name: "Comfortaa-light", size: 14)
                    self.dateButton.titleLabel?.font = UIFont(name: "Comfortaa-light", size: 14)
                    self.dateButton.setTitleColor(UIColor(red: 255, green: 255, blue: 255, alpha: 0.5), for: .normal)
                    self.timeButton
                        .setTitleColor(UIColor(red: 255, green: 255, blue: 255, alpha: 0.5), for: .normal)
                    self.submitButton.isEnabled = true
                    self.tabBarController?.selectedIndex = 0
                })
            }else{
                DataService.instance.updateExperience(expID: editingExperience.expID, userData: userData, iconImage: profileImage.image!, bannerImage: bannerImage.image!, oldCategory: oldCategory, newCategory: categoryLabel.text!, handler: {
                    let editedExp = RecruiterActiveExperience(title: self.nameTextField.text!, date: self.dateButton.currentTitle!, time: self.timeButton.currentTitle!, accepted: self.editingExperience.accepted, pending: self.editingExperience.pending, imageURL: self.editingExperience.imageURL, expID: self.editingExperience.expID, organisation: self.editingExperience.organisation, bannerURL: self.editingExperience.bannerPhotoURL, rating: self.editingExperience.rating, age: self.ageGroupLabel.text!, location: self.addressTextField.text!, category: self.categoryLabel.text!, city: self.cityLabel.text!, description: self.descriptionTextView.text)
                    NotificationCenter.default.post(name: Notification.Name("updateInfo"), object: editedExp)
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true
                    self.submitButton.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }else{
            submitButton.isEnabled = true
            performSegue(withIdentifier: "message", sender: nil)
        }
        
    }
    
    func checkForm() ->Bool{
        if (nameTextField.text?.count)! > 0{
            if categoryLabel.text != "Select Category"{
                if ageGroupLabel.text != "Select Age Group"{
                    if timeButton.currentTitle != "HH:MM"{
                        if dateButton.currentTitle != "DD/MM/YYYY"{
                            if (addressTextField.text?.count)! > 0{
                                if cityLabel.text != "Select a City"{
                                    if (descriptionTextView.text.count) > 0{
                                        if profileImage.image != UIImage(named: "profileDefault"){
                                            if bannerImage.image != UIImage(named: "bannerDefault"){
                                                return true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage{
            if pickerTypeisProfile == true{
                profileImage.image = image
            }else{
                bannerImage.image = image
            }
            
        }else{
            print("Marton: A valid image wasn't selected")
        }
        
        
        
        imagePicker.dismiss(animated: true, completion: nil)
        indicator.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "date"{
            let destination = segue.destination as! RecruitPostDateVC
            if dateButton.currentTitle! != "DD/MM/YYYY"{
                destination.selectedDate = "\(dateButton.currentTitle!) \(timeButton.currentTitle!)"
            }
        }
        
        if segue.identifier == "message"{
            let destination = segue.destination as! LoginMessage
            destination.buttonText = "Close"
            destination.message = "All fields are required to fill and photos need to be selected!"
        }
        
        if segue.identifier == "location"{
            let destination = segue.destination as! WalkthroughLocationVC
            destination.isSignUp = true
        }
        
        if segue.identifier == "category"{
            let destination = segue.destination as! RecruitPostCategoryVC
            destination.isPickerCategory = isPickerCategory
            
            if isPickerCategory == true{
                if categoryLabel.text != "Select Category"{
                    destination.selectedCategory = categoryLabel.text!
                }
            }else{
                if ageGroupLabel.text != "Select Age Group"{
                    destination.selectedAgeGroup = ageGroupLabel.text!
                }
            }
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
