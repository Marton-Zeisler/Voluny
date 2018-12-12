//
//  OpenedExperienceReviewsVC.swift
//  Voluny
//


import UIKit
import Cosmos
import Firebase

class OpenedExperienceReviewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var reviewsTableview: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var noLabel: UILabel!
    
    var isWriteMode = false
    
    var reviews = [Review]()
    var experienceID: String!
    
    var averageScore = 0.0
    
    @IBOutlet weak var writeReviewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTableview.delegate = self
        reviewsTableview.dataSource = self
        
        if Auth.auth().currentUser?.isAnonymous ?? true{
            writeReviewButton.isHidden = true
        }else{
            writeReviewButton.isHidden = false //!isWriteMode
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.averageScore = 0
        DataService.instance.getReviewsForExperience(expID: experienceID) { (returnedReviews) in
            if returnedReviews.count > 0{
                self.reviews = returnedReviews
                self.noLabel.isHidden = true
                
                for each in self.reviews{
                    print(each.rating)
                    self.averageScore = self.averageScore + each.rating
                }
                self.averageScore = self.averageScore / Double(self.reviews.count)
                self.averageScore = self.roundToPlaces(value: self.averageScore, places: 1)
                self.scoreLabel.text = "\(self.averageScore) / 5"
                self.ratingView.rating = self.averageScore
                self.reviewsTableview.reloadData()
                
                DataService.instance.updateRating(expID: self.experienceID, newRating: self.averageScore, handler: {
                    print("updated rating to: ", self.averageScore)
                })
                
            }else{
                self.noLabel.isHidden = false
            }
        }
    }
    
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TappedExperienceReviewCell else{
            return UITableViewCell()
        }
        cell.configureCell(review: reviews[indexPath.row])
        
        if indexPath.row % 2 == 0{
            print("not white")
            cell.contentView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        }else{
            cell.contentView.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    @IBAction func writeReviewTapped(_ sender: Any) {
        performSegue(withIdentifier: "write", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "write"{
            let destination = segue.destination as! WriteReviewVC
            destination.expID = experienceID
        }
    }
    

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
