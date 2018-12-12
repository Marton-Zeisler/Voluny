//
//  NoCityFoundCell.swift
//  Voluny
//


import UIKit

class NoCityFoundCell: UITableViewCell {

    @IBOutlet var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 30))
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
