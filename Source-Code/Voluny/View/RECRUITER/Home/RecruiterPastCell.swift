//
//  RecruiterPastCell.swift
//  Voluny
//


import UIKit
import SDWebImage

class RecruiterPastCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    
    func configureCell(exp: RecruiterActiveExperience){
        titleLabel.text = exp.title
        dateLabel.text = exp.date
        timeLabel.text = exp.time
        peopleLabel.text = "\(exp.accepted) Volunteers Accepted"
        image.clipsToBounds = true
        image.layer.cornerRadius = image.frame.size.height / 2
        image.sd_setImage(with: URL(string: exp.imageURL))
        
    }

    
    
}
