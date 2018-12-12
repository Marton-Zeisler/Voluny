//
//  TappedNameView.swift
//  Voluny
//


import UIKit

class TappedNameView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 6
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

}
