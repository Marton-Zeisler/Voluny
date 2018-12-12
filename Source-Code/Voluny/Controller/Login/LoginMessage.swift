//
//  SigninRetryVC.swift
//  Voluny
//


import UIKit

class LoginMessage: UIViewController {

    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var actionButton: WalkthroughRoundedButton!
    
    var message = ""
    var buttonText = ""
    var icon = ""
    
    var isResetMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if message.count > 0{
            messageLabel.text = message
        }
        
        if buttonText.count > 0{
            actionButton.setTitle(buttonText, for: .normal)
        }

    }
    

    @IBAction func retryTapped(_ sender: Any) {
        if isResetMode == true{
            NotificationCenter.default.post(name: Notification.Name("successReset"), object: nil)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        if isResetMode == true{
            NotificationCenter.default.post(name: Notification.Name("successReset"), object: nil)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
