//
//  RoundedView.swift
//  OrthoFX
//
//  Created by Marton Zeisler on 2018. 09. 06..
//  Copyright © 2018. OrthoFX. All rights reserved.
//

import UIKit

extension UIView{
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var border: CGFloat{
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // Recommended settings for shadow: Black(51% opacity), 1 shadow Opacity, 7 shadow radius, 0 width x 2 height
    @IBInspectable var shadowColor: UIColor{
        get{
            return UIColor(cgColor: layer.shadowColor!)
        }set{
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        get{
            return layer.shadowOpacity
        }set{
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        get{
            return layer.shadowRadius
        }set{
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize{
        get{
            return layer.shadowOffset
        }set{
            layer.shadowOffset = newValue
        }
    }
    
    
    
    
}
