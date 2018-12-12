//
//  RecruiterLoginSelectionVC.swift
//  Voluny
//


import UIKit

class RecruiterLoginSelectionVC: UIViewController {
    
    
    @IBOutlet weak var recruiterTick: UIImageView!
    @IBOutlet weak var recruiterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Resetting the views
        recruiterTick.alpha = 0.0
        recruiterView.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        animateTappedSignUp()
    }
    
    func animateTappedSignUp(){
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.7, animations: {
            self.recruiterTick.alpha = 1.0
            self.recruiterView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
        }) { (success) in
            self.performSegue(withIdentifier: "signup", sender: nil)
        }
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        performSegue(withIdentifier: "signin", sender: nil)
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
}
