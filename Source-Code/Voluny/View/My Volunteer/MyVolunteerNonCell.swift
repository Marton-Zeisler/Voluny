//
//  MyVolunteerNonCell.swift
//  Voluny
//


import UIKit

class MyVolunteerNonCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var optionsButton: UIButton!
    
    @IBOutlet weak var optionsMenu: UIView!
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    
    
    @IBOutlet weak var whiteDotsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets.init(top: 0, left: 29, bottom: 18, right: 29))
        contentView.layer.cornerRadius = 8

    }
    
    func configureCell(experience: MyVolunteerExperience, section: Int){
        titleLabel.text = experience.title
        
        if section == 2{
            contentView.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
            contentView.layer.borderWidth = CGFloat(integerLiteral: 1)
            optionsButton.isHidden = true
            titleLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
        }else{
            contentView.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
            contentView.layer.borderWidth = CGFloat(integerLiteral: 1)
            titleLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
        }
        
    }
    

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
