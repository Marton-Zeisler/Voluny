//
//  TappedExperienceReviewCell.swift
//  Voluny
//


import UIKit
import Cosmos

class TappedExperienceReviewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(review: Review){
        nameLabel.text = review.reviewerName
        starsView.rating = review.rating
        dateLabel.text = review.date
        reviewTextLabel.text = review.reviewDescription
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
