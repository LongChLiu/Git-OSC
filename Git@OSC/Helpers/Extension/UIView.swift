//
//  UIView.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/29.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation

extension UIView {
    func addWidth(_ width: CGFloat) {
        self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width + width, height: self.frame.size.height)
    }
    
    func addHeight(_ height: CGFloat) {
        self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height + height)
    }
    
    func setHeight(_ height: CGFloat) {
        self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: height)
    }
    
    func addY(_ y: CGFloat) {
        self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y + y, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func setY(_ y: CGFloat) {
        self.frame = CGRect.init(x: self.frame.origin.x, y: y, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func addX(_ x: CGFloat) {
        self.frame = CGRect.init(x: self.frame.origin.x + x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func setX(_ x:CGFloat) {
        self.frame = CGRect.init(x: x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
    }
}


extension UIView {
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
