//
//  RecruitProfileVC.swift
//  Voluny
//


import UIKit
import Firebase
import MessageUI
import SafariServices

class RecruitProfileVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var organisationLabel: UILabel!
    @IBOutlet weak var recruiterLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var currentUser: Recruiter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func loadInfo(){
        DataService.instance.getRecruiterInfo(userID: (Auth.auth().currentUser?.uid)!) { (recruiter) in
            self.currentUser = recruiter
            self.organisationLabel.text = recruiter.organisation
            self.recruiterLabel.text = recruiter.recruiter
            self.emailLabel.text = recruiter.email
            self.phoneLabel.text = recruiter.phoneNumber
            self.cityLabel.text = recruiter.city
        }
    }
    
    @IBAction func editTapped(_ sender: Any) {
        performSegue(withIdentifier: "edit", sender: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let firstVC = storyboard?.instantiateViewController(withIdentifier: "start")
            DispatchQueue.main.async {
                self.present(firstVC!, animated: false, completion: nil)
            }
            print("Firebase: Successfully signed out!")
        }catch let signOutError as NSError{
            print("Error signing out: \(signOutError)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            let destination = segue.destination as! RecruitEditProfileVC
            destination.selectedUser = currentUser
        }
    }
    
    @IBAction func feedbackTapped(_ sender: UIButton){
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setSubject("Feedback about Voluny")
        mail.setMessageBody("Dear Voluny Team,\nHere's my feedback for you guys:\n", isHTML: true)
        mail.setToRecipients(["marton.zeisler@gmail.com"])
        present(mail, animated: true, completion: nil)
    }
    
    @IBAction func supportTapped(_ sender: UIButton){
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setSubject("Support Needed about Voluny")
        mail.setMessageBody("Dear Voluny Team,\nI need some help with the following:\n", isHTML: true)
        mail.setToRecipients(["marton.zeisler@gmail.com"])
        present(mail, animated: true, completion: nil)
    }
    
    @IBAction func aboutTapped(_ sender: UIButton){
        let url = URL(string: "https://martonz.webflow.io/projects#Voluny")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    

}
