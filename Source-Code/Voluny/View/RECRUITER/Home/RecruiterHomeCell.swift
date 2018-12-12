//
//  RecruiterHomeCell.swift
//  Voluny
//


import UIKit
import SDWebImage

class RecruiterHomeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var acceptedLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var numberCircleView: UIView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var expImage: UIImageView!
    @IBOutlet weak var imageWidthConstrainty: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        //contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 29, 18, 29))
        backView.layer.cornerRadius = 8
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.20
        backView.layer.shadowRadius = 5
        backView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        imageWidthConstrainty.constant = CGFloat( 10 * Int(round(self.frame.height*0.5 / 10.0)))
        imageHeightConstraint.constant = imageWidthConstrainty.constant
        numberCircleView.layer.cornerRadius = numberCircleView.frame.height / 2
        expImage.layer.cornerRadius = imageHeightConstraint.constant / 2
        expImage.clipsToBounds = true
    }
    
    func configureCell(exp: RecruiterActiveExperience){
        titleLabel.text = exp.title
        dateLabel.text = exp.date
        timeLabel.text = exp.time
        acceptedLabel.text = "\(exp.accepted) Accepted"
        numberLabel.text = exp.pending
        expImage.sd_setImage(with: URL(string: exp.imageURL))
        
        
    }


    

}
