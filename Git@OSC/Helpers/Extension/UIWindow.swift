//
//  UIWindow.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/27.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation

fileprivate let textHUD: MBProgressHUD = {
    let textHUD = MBProgressHUD()
    textHUD.mode = .text
    textHUD.removeFromSuperViewOnHide = true
    return textHUD
}()

extension UIWindow {
    func show(text: String) {
        addSubview(textHUD)
        textHUD.label.text = text
        textHUD.show(animated: true)
        textHUD.hide(animated: true, afterDelay: 0.7)
    }
}
