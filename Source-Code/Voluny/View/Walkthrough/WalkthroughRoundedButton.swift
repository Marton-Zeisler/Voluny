//
//  WalkthroughRoundedButton.swift
//  Voluny
//


import UIKit

class WalkthroughRoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 27.0
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 7
        self.layer.shadowOffset = .zero
        
        
    }

}
