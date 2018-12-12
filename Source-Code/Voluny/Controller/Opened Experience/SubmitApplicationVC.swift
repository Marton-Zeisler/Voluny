//
//  SubmitApplicationVC.swift
//  Voluny


import UIKit
import Firebase
class SubmitApplicationVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var submitButton: WalkthroughRoundedButton!
    @IBOutlet weak var textView: UITextView!
    var experience: Experience?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        textView.delegate = self
        enableButton(false)

    }
    
    func textViewDidChange(_ textView: UITextView) {
        enableButton(textView.hasText)
    }
    
    
    func enableButton(_ enable: Bool){
        if enable{
            submitButton.isEnabled = true
            submitButton.alpha = 1.0
        }else{
            submitButton.isEnabled = false
            submitButton.alpha = 0.65
        }
    }
    
    @IBAction func submitTapped(_ sender: Any){
        submitButton.isEnabled = false
        if let experience = experience{
            DataService.instance.volunteerDescription(uid: (Auth.auth().currentUser?.uid)!, expID: experience.id, descr: textView.text)
            DataService.instance.addToLatestUserApplied(userID: (Auth.auth().currentUser?.uid)!, experience: experience, status: "pending")
            DataService.instance.applyUser(experienceID: experience.id, userID: (Auth.auth().currentUser?.uid)!, recruiter: experience.recruiter)
            DataService.instance.volunteerAppliesRecruiterNotify(recruiterID: experience.recruiter, volunteerID: (Auth.auth().currentUser?.uid)!, expID: experience.id)
            performSegue(withIdentifier: "success", sender: nil)
        }
        submitButton.isEnabled = true
    }
    
    @IBAction func backTapped(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
  

}
