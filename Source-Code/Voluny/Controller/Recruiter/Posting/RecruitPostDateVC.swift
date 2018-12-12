//
//  RecruitPostDateVC.swift
//  Voluny
//


import UIKit

class RecruitPostDateVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        
        
        if selectedDate.count > 1{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm" // We want American AM/PM style instead
            datePicker.date = dateFormatter.date(from: selectedDate)!
        }
    }

    @IBAction func doneTapped(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm" // We want American AM/PM style instead
        let dateString = formatter.string(from: datePicker.date)
        NotificationCenter.default.post(name: Notification.Name("setDate"), object: dateString)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    


}
