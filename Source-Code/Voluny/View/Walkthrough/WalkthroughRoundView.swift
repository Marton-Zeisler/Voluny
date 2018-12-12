//
//  WalkthroughRoundView.swift
//  Voluny
//


import UIKit

class WalkthroughRoundView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 8.0
    }

}
