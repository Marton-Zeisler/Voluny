//
//  ManageViews.swift
//  Voluny
//


import UIKit

class ManageViews: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
    
    }
    
    func isShadowEnabled(enabled: Bool){
        if enabled{
            self.layer.shadowColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1).cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 4.0
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
        }else{
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.shadowOpacity = 0
            self.layer.shadowRadius = 0
        }
    }


}
