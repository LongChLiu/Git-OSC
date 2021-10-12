//
//  UIViewController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/14.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

extension UIViewController {
    var hasNavigationBar: Bool {
        guard let navController = self.navigationController else {
            return false
        }
        return !navController.navigationBar.isHidden
    }
    
    var hasTabBar: Bool {
        guard let tabBarController = self.tabBarController else {
            return false
        }
        return !tabBarController.tabBar.isHidden
    }
}
