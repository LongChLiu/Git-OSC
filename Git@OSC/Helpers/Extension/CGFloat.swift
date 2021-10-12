//
//  CGFoloat.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/13.
//  Copyright © 2018 Git@OSC. All rights reserved.
//
import UIKit
import Foundation


extension CGFloat {
    static var screenWidth: CGFloat { return UIScreen.main.bounds.width }
    static var screenHeight: CGFloat { return UIScreen.main.bounds.height }
    static var navigationBarTotalHeight: CGFloat {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        return statusBarHeight + 44
    }
    
    static var tabBarTotalHeight: CGFloat {
        return isIphoneX ? 83 : 49
    }
    
    static func cellMaxWidth(withPortrait: Bool) -> CGFloat {
        if withPortrait {
            return CGFloat.screenWidth - 36 - 24
        }
        return CGFloat.screenWidth - 16
    }
    
    static let sectionHeight: CGFloat = 40
}
