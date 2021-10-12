//
//  LoginTextField.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/9.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField {
    @IBInspectable var leftImage: UIImage = .init() {
        didSet {
            let imageView = UIImageView.init(frame: CGRect.init(origin: .zero, size: .init(width: 20, height: 20)))
            imageView.image = leftImage
            imageView.tintColor = .normalText
            self.leftView = imageView
            self.leftViewMode = .always
            self.tintColor = .normalText
            self.font = UIFont.middle.normal
        }
    }
    
//    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//        var rect = super.leftViewRect(forBounds: bounds)
//        return rect
//    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).insetBy(dx: 10, dy: 0)
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let color = UIColor.normalText
        context?.setStrokeColor(color.cgColor)
        context?.setLineWidth(0.5)
        context?.stroke(.init(x: 30, y: rect.height, width: rect.width - 40, height: 1))
        // Drawing code
    }


}
