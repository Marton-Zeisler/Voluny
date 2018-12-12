//
//  LoginSelectionVC.swift
//  Voluny
//


import UIKit

class LoginSelectionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

 
    @IBAction func signUpTapped(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: nil)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        performSegue(withIdentifier: "signIn", sender: nil)
    }
    
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("loginClosed"), object: nil)
    }
    
 
    

}
