//
//  UserTypeVC.swift
//  Voluny
//


import UIKit
import Firebase

class UserTypeVC: UIViewController {
    
    // Volunteer
    @IBOutlet weak var volunteerTick: UIImageView!
    @IBOutlet weak var volunteerView: UIView!
    
    // Recruiter
    @IBOutlet weak var recruiterTick: UIImageView!
    @IBOutlet weak var recruiterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Resetting the views
        volunteerTick.alpha = 0.0
        volunteerView.backgroundColor = UIColor.clear
        recruiterTick.alpha = 0.0
        recruiterView.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func volunteerTapped(_ sender: Any) {
        animateTappedVolunteer(true)
        Auth.auth().signInAnonymously() { (user, error) in
            print("Firebase: Anonymous singed in!")
            self.performSegue(withIdentifier: "toHome", sender: nil) // We take the user to the home screen of volunteer
        }
    }
    
    @IBAction func recruiter(_ sender: Any) {
        animateTappedVolunteer(false)
    }
    
    func animateTappedVolunteer(_ volunteer: Bool){
        view.isUserInteractionEnabled = false
        if volunteer{
            UIView.animate(withDuration: 0.7){
                self.volunteerTick.alpha = 1.0
                self.volunteerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
            }
        }else{
            
            UIView.animate(withDuration: 0.7, animations: {
                self.recruiterTick.alpha = 1.0
                self.recruiterView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
            }) { (success) in
                self.performSegue(withIdentifier: "recruiter", sender: nil)
            }
        }
    }

}
