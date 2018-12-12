//
//  RecruiterTappedTopView.swift
//  Voluny
//


import UIKit

class RecruiterTappedTopView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 6
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

}
