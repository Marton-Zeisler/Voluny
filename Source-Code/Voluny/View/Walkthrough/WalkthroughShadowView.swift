//
//  WalkthroughRoundedView.swift
//  Voluny
//


import UIKit

class WalkthroughShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()

//        self.clipsToBounds = false
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.layer.shadowRadius = 4
//        self.layer.shadowPath = UIBezierPath(roundedRect: (superview?.bounds)!, cornerRadius: 8).cgPath
//        self.layer.shouldRasterize = true
        
        
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 6.0
        //self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0.0).cgPath
        

        
    }

}
