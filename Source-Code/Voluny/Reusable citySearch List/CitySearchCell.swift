//
//  CItySearchCell.swift
//  Voluny
//


import UIKit

class CitySearchCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var circle: UIView!
    
    func configureCell(isCity: Bool, text: String){
        cityLabel.text = text
        if !isCity{
            cityLabel.textColor = #colorLiteral(red: 0.8719156981, green: 0.3707225621, blue: 0.4942278266, alpha: 1)
            circle.isHidden = false
        }else{
            cityLabel.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
            circle.isHidden = true
        }
    }
    

}
