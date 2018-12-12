//
//  OpenedExperienceVC.swift
//  Voluny
//


import UIKit
import Cosmos
import SDWebImage
import Firebase

class OpenedExperienceVC: UIViewController {
    
    var selectedExperience: Experience!
    
    @IBOutlet weak var bannerPhoto: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var preciseLocationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var volunteerButton: WalkthroughRoundedButton!
    @IBOutlet weak var volunteer2Button: WalkthroughRoundedButton!
    
    var isApplied = false
    
    @IBOutlet weak var profilePicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if isApplied ==  true{
            volunteerButtonApplied()
        }
        
        bannerPhoto.sd_setImage(with: URL(string: selectedExperience.bannerPhoto))
        locationLabel.text = selectedExperience.location
        titleLabel.text = selectedExperience.title
        starsView.rating = selectedExperience.rating
        dateLabel.text = selectedExperience.date
        ageLabel.text = selectedExperience.ageGroup
        preciseLocationLabel.text = selectedExperience.preciseLocation
        descriptionTextView.text = selectedExperience.longDescription
        profileImageView.sd_setImage(with: URL(string: selectedExperience.iconPhoto))
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("userLoggedIn"), object: nil)
        
        let imageHeight = CGFloat( 10 * Int(round(view.frame.height*0.2 / 10.0)))
        profilePicHeightConstraint.constant = imageHeight
        profileWidthConstraint.constant = imageHeight
        profileImageView.layer.cornerRadius = imageHeight/2
        profileImageTopConstraint.constant = -imageHeight/2
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBarController?.tabBar.invalidateIntrinsicContentSize()
    }
    
    func volunteerButtonApplied(){
        volunteerButton.setTitle("Applied", for: .normal)
        volunteerButton.setTitleColor(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), for: .normal)
        volunteerButton.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        volunteerButton.isEnabled = false
        
        
        volunteer2Button.setTitle("Applied", for: .normal)
        volunteer2Button.setTitleColor(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), for: .normal)
        volunteer2Button.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        volunteer2Button.isEnabled = false
    }
    
    // User taps on volunteer, signed in or anonymous?
    @IBAction func volunteerTapped(_ sender: Any){
        if Auth.auth().currentUser?.isAnonymous == true{
            // user is not signed in, sign in/up user
            performSegue(withIdentifier: "toLogin", sender: nil)
        }else{
            // user is signed in, button is enabled so user didn't apply yet
            self.hidesBottomBarWhenPushed = true
            performSegue(withIdentifier: "apply", sender: nil)
        }
    }
    
    @objc func userLoggedIn(_ notification: Notification){
        if let isSignIn = notification.object as? Bool{
            // user just signed in -> check if applied already if no, let's apply
            //signed up - let's apply
            if isSignIn{
                DataService.instance.didUserApply(experienceID: selectedExperience.id, userID: (Auth.auth().currentUser?.uid)!) { (applied) in
                    if applied{
                        self.volunteerButtonApplied()
                        self.performSegue(withIdentifier: "appliedAlready", sender: nil)
                    }else{
                        self.hidesBottomBarWhenPushed = true
                        self.performSegue(withIdentifier: "apply", sender: nil)
                    }
                }
            }else{
                self.hidesBottomBarWhenPushed = true
                performSegue(withIdentifier: "apply", sender: nil)
            }
        }
    }
    
    
    @IBAction func reviewsTapped(_ sender: Any) {
        self.hidesBottomBarWhenPushed = true
        performSegue(withIdentifier: "toReviews", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toReviews"{
            let destinationVC = segue.destination as! OpenedExperienceReviewsVC
            destinationVC.experienceID = selectedExperience.id
        }
        
        if segue.identifier == "apply"{
            let applyVC = segue.destination as! SubmitApplicationVC
            applyVC.experience = selectedExperience
        }
        
        if segue.identifier == "appliedAlready"{
            let errorVC = segue.destination as! LoginMessage
            errorVC.message = "You already applied to this experience, try to apply to another one instead."
            errorVC.buttonText = "Okay"
        }
    }
    

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
