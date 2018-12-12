//
//  LocationSuggestionCell.swift
//  Voluny
//


import UIKit

class LocationSuggestionCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        if label.text == "Use current location"{
//            label.textColor = UIColor(red:0.68, green:0.26, blue:0.45, alpha:1.0)
//        }else{
//            label.textColor = UIColor(red:0.01, green:0.01, blue:0.01, alpha:1.0)
//        }
        
        
        label.textColor = UIColor(red:0.68, green:0.26, blue:0.45, alpha:1.0)
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
