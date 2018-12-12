//
//  CustomTextField.swift
//  Voluny
//


import UIKit

extension UITextField {
    func modifyClearButton(with image : UIImage) {
        clearButtonMode = .never
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(_:)), for: .touchUpInside)
        rightView = clearButton
        rightViewMode = .whileEditing
    }
    
    @objc func clear(_ sender : AnyObject) {
        self.text = ""
        rightViewMode = .whileEditing
        sendActions(for: .editingChanged)
    }
    
}
