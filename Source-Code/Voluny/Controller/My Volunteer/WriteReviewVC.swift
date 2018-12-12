//
//  WriteReviewVC.swift
//  Voluny
//


import UIKit
import Cosmos
import Firebase

class WriteReviewVC: UIViewController {
    
    @IBOutlet weak var rating: CosmosView!
    
    @IBOutlet weak var starsLabel: UILabel!
    
    @IBOutlet weak var textview: KMPlaceholderTextView!
    
    var expID = ""
    
    var ratingScore = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        rating.didTouchCosmos = {rating in
            self.starsLabel.text = "\(rating) / 5 stars"
            self.ratingScore = rating
        }

    }
    
    

    @IBAction func submitTapped(_ sender: Any) {
        if checkData() == true{
            DataService.instance.createNewReview(expID: expID, uid: (Auth.auth().currentUser?.uid)!, desc: textview.text, rating: ratingScore, handler: {
                self.dismiss(animated: true, completion: nil)
            })
        }else{
            performSegue(withIdentifier: "error", sender: nil)
        }
    }
    
    func checkData() ->Bool{
        if starsLabel.text != "0 / 5 stars"{
            if textview.text.count > 1{
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "error"{
            let destination = segue.destination as! LoginMessage
            destination.buttonText = "Try again"
            destination.message = "All fields are required to be filled out"
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
