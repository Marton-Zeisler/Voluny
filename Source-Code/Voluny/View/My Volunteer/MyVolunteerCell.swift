//
//  MyVolunteerCell.swift
//  Voluny
//


import UIKit

class MyVolunteerCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var optionsMenu: UIView!
    
    @IBOutlet weak var optionButton: UIButton!
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var reviewsButton: UIButton!
    
    @IBOutlet weak var redDotsButton: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImage.layer.masksToBounds = false
        backgroundImage.clipsToBounds = true
        backgroundImage.layer.cornerRadius = 8
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets.init(top: 0, left: 29, bottom: 20, right: 29))
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1).cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 4.0
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func configureCell(experience: MyVolunteerExperience){
        titleLabel.text = experience.title
        locationLabel.text = experience.location
        DateLabel.text = experience.date
        timeLabel.text = experience.time
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
