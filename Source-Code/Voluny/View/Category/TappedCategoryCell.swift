//
//  TappedCategoryCell.swift
//  Voluny
//


import UIKit
import Cosmos
import SDWebImage

class TappedCategoryCell: UITableViewCell {
    
    

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var shortDescrLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets.init(top: 0, left: 29, bottom: 18, right: 29))
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1).cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 4.0
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        photo.layer.cornerRadius = photo.frame.height / 2
        photo.clipsToBounds = true
    }
    
    func configureCell(experience: Experience){
        locationLabel.text = experience.location
        titleLabel.text = experience.title
        shortDescrLabel.text = experience.shortDescription
        calendarLabel.text = experience.date
        peopleLabel.text = experience.ageGroup
        photo.sd_setImage(with: URL(string: experience.iconPhoto))
        starsView.rating = experience.rating
    }

}
