//
//  TabBarExtension.swift
//  Voluny
//


import UIKit

extension UIViewController{

    func changeTabBarBackground(color: UIColor){
        let x = Double(UIScreen.main.bounds.width / 5.0)
        let y = Double(self.tabBarController!.tabBar.frame.size.height)
        let indicatorBackground: UIImage? = self.image(from: color, for: CGSize(width: x, height: y))
        UITabBar.appearance().selectionIndicatorImage = indicatorBackground
    }

    func image(from color: UIColor, for size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        autoreleasepool {
            UIGraphicsBeginImageContext(rect.size)
        }
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        //sizeThatFits.height =  UIScreen.main.bounds.height * 0.123 //65 // adjust your size here
        

        if UIScreen.main.bounds.height == 667{ // iphone 8
            sizeThatFits.height = 65
        }else if UIScreen.main.bounds.height >= 812{ // iphone x
            sizeThatFits.height = 100
        }else if UIScreen.main.bounds.height == 736{
            sizeThatFits.height = 65
        }else if UIScreen.main.bounds.height == 568{
            sizeThatFits.height = 55
        }else{
            sizeThatFits.height = 65
        }
        
        
        
        return sizeThatFits
    }
}
