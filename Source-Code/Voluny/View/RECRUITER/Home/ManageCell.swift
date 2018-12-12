//
//  ManageCell.swift
//  Voluny
//


import UIKit

class ManageCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets.init(top: 0, left: 29, bottom: 10, right: 29))
        contentView.layer.cornerRadius = 6
        
        contentView.layer.shadowColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1).cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 4.0
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
