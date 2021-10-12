//
//  UIViewController.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/16.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import Alamofire

extension UINavigationController {
    func pushViewControllerHideTabBar(_ viewController: UIViewController, animated: Bool) -> Void {
        viewController.hidesBottomBarWhenPushed = true
        self.pushViewController(viewController, animated: animated)
    }
    
    static var current: UINavigationController? {
        var parent: UIViewController?
        if let window = UIApplication.shared.delegate?.window,let rootVC = window?.rootViewController {
            parent = rootVC
            while (parent?.presentedViewController != nil) {
                parent = parent?.presentedViewController!
            }
            
            if let tabbar = parent as? UITabBarController ,let nav = tabbar.selectedViewController as? UINavigationController {
                return nav
            }else if let nav = parent as? UINavigationController {
                return nav
            }
        }
        return nil
    }
}


