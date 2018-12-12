//
//  RecruiterTappedNameVC.swift
//  Voluny
//


import UIKit
import Firebase
import SDWebImage

class RecruiterTappedNameVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userDescriptionTextView: UITextView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var titleNameLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedUser: Volunteer!
    var selectedUserPlace = "pendingPeople"
    var selectedUserID = ""
    var expID: String!
    
    var selectedExperience: RecruiterActiveExperience!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.isHidden = true
        userImage.layer.cornerRadius = userImage.frame.size.height / 2
        userImage.clipsToBounds = true
        
        activityIndicator.startAnimating()
        loadUser()
    }
    
    func loadUser(){
        var fullName = selectedUser.name.split(separator: " ")
        firstLabel.text = String(fullName[0])
        lastLabel.text = String(fullName[1])
        emailLabel.text = selectedUser.email
        dateLabel.text = selectedUser.date
        phoneLabel.text = selectedUser.phone
        cityLabel.text = selectedUser.city
        titleNameLabel.text = selectedUser.name
        
        userImage.sd_setImage(with: URL(string: selectedUser.profileURL))
        userImage.isHidden = false
        
        DataService.instance.getDescriptionFromUser(uid: (selectedUser.ID), expID: expID) { (descr) in
            if descr.count == 0{
                self.userDescriptionTextView.text = "User has not given any description."
            }else{
                self.userDescriptionTextView.text = descr
            }
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    
    @IBAction func acceptedTapped(_ sender: Any) {
        DataService.instance.activeMoveVolunteer(recruiterID: (Auth.auth().currentUser?.uid)!, volunteerID: selectedUser.ID, from: selectedUserPlace, to: "acceptedPeople", expID: expID)
        NotificationCenter.default.post(name: Notification.Name("pending"), object: nil)
        DataService.instance.addToLatestUserApplied(userID: selectedUser.ID, status: "accepted", active: selectedExperience)
        DataService.instance.notifyVolunteer(expID: selectedExperience.expID, volunteerID: selectedUser.ID, status: "accepted")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func declinedTapped(_ sender: Any) {
        DataService.instance.activeMoveVolunteer(recruiterID: (Auth.auth().currentUser?.uid)!, volunteerID: selectedUser.ID, from: selectedUserPlace, to: "declinedPeople", expID: expID)
        DataService.instance.addToLatestUserApplied(userID: selectedUser.ID, status: "declined", active: selectedExperience)
        DataService.instance.notifyVolunteer(expID: selectedExperience.expID, volunteerID: selectedUser.ID, status: "declined")
        self.navigationController?.popViewController(animated: true)

    }
    

    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
