//
//  HomeBannerView.swift
//  Voluny
//


import UIKit

class HomeBannerView: UIView{

    
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    
}
