//
//  ProfileVC.swift
//  Voluny
//


import UIKit
import Firebase
import SDWebImage
import MessageUI
import SafariServices



class ProfileVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var selectedUser: Volunteer!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.isHidden = true
        indicator.startAnimating()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginClosed), name: Notification.Name("loginClosed"), object: nil)
        
    }
    
    @objc func loginClosed(_ notification: Notification){
        self.tabBarController?.selectedIndex = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if Auth.auth().currentUser?.isAnonymous == true{
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "login", sender: nil)
            })
        }else{
            loadUserInfo() // this produces crash after signing in, maybe consider viewdidappear
        }
    }
    
    func loadUserInfo(){
        DataService.instance.getUserInfo(userID: (Auth.auth().currentUser?.uid)!) { (volunteer) in
            self.selectedUser = volunteer
            let names = volunteer.name.split(separator: " ")
            self.firstLabel.text = String(names[0])
            self.lastLabel.text = String(names[1])
            self.emailLabel.text = volunteer.email
            self.dateLabel.text = volunteer.date
            self.phoneLabel.text = volunteer.phone
            self.cityLabel.text = volunteer.city
            self.profileImage.sd_setImage(with: URL(string: volunteer.profileURL))
            self.profileImage.isHidden = false
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
    }

    @IBAction func editTapped(_ sender: Any) {
        self.hidesBottomBarWhenPushed = true

        performSegue(withIdentifier: "edit", sender: nil)
        
        self.hidesBottomBarWhenPushed = false

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            let destination = segue.destination as! EditProfileVC
            destination.selectedUser = selectedUser
        }
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
