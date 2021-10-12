//
//  TextHUDPresentable.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/21.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation

private var associatedKey = "TextHUD"

//MARK:- TextHUDPresentable
protocol TextHUDPresentable: class { }

extension TextHUDPresentable where Self: UIViewController {
    var textHUD: MBProgressHUD {
        get {
            guard let res = objc_getAssociatedObject(self, &associatedKey) as? MBProgressHUD else {
                fatalError("It should be set before used")
            }
            return res
        }
        
        set {
            objc_setAssociatedObject(self, &associatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setupTextHUD() {
        textHUD = MBProgressHUD()
        textHUD.label.adjustsFontSizeToFitWidth = true
        textHUD.mode = .text
        view.addSubview(textHUD)
    }
}
