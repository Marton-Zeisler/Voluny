//
//  RecruitPostCategoryVC.swift
//  Voluny
//


import UIKit

class RecruitPostCategoryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let categoryNames = ["ANIMAL", "CHILDREN", "COMMUNITY", "DISABILITY", "EDUCATION", "ENVIRONMENT", "HEALTH", "HOMELESS", "SENIOR"]
    
    let ageGroups = ["All Ages", "Teens", "Adults"]
    
    var selectedCategory = ""
    var selectedAgeGroup = ""
    
    var isPickerCategory = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if isPickerCategory == true{
            titleLabel.text = "Select category"
        }else{
            titleLabel.text = "Select age group"
        }
        
        if selectedCategory.count > 0 && isPickerCategory == true{
            pickerView.selectRow(categoryNames.index(of: selectedCategory)!, inComponent: 0, animated: true)
        }
        
        if selectedAgeGroup.count > 0 && isPickerCategory == false{
            pickerView.selectRow(ageGroups.index(of: selectedAgeGroup)!, inComponent: 0, animated: true)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isPickerCategory == true{
            return categoryNames.count
        }else{
            return ageGroups.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isPickerCategory == true{
            return categoryNames[row]
        }else{
            return ageGroups[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: isPickerCategory ? categoryNames[row] : ageGroups[row], attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.831372549, green: 0.2745098039, blue: 0.4196078431, alpha: 1)])
        return attributedString
    }
    
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if isPickerCategory == true{
            NotificationCenter.default.post(name: Notification.Name("setCategory"), object: categoryNames[pickerView.selectedRow(inComponent: 0)])
        }else{
            NotificationCenter.default.post(name: Notification.Name("setAge"), object: ageGroups[pickerView.selectedRow(inComponent: 0)])
        }

        
        
        dismiss(animated: true, completion: nil)
    }
    


    

  

}
