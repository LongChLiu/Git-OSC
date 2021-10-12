//
//  UIColor.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/12.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import UIKit



extension UIColor {
    private static var isNight: Bool {
        return CurrentUserManger.isNightMode.value
    }
    
    static var lucidBlack: UIColor { return UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3) }
    
    static var icon: UIColor {
        return UIColor.init(red: 210/255, green: 20/255, blue: 23/255, alpha: 1)
    }
    
    static var theme: UIColor {
        return UIColor.init(red: 52/255, green: 79/255, blue: 132/255, alpha: 1)
    }
    
    static var themeTextUnselected: UIColor {
        return UIColor.init(red: 85/255, green: 130/255, blue: 170/255, alpha: 1)
    }
    
    static var lucidGray: UIColor {
        return UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    }
    
    static var normalText: UIColor {
        return isNight ? UIColor.white : UIColor.black
    }
    
    static var normalBackgroud: UIColor {
        return isNight ? UIColor(red: 32/255, green: 38/255, blue: 49/255, alpha: 1) :  UIColor.white
    }
    
    static var deepBackgroud: UIColor {
        return isNight ? UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1) 
    }
    
    static var selected: UIColor {
        return isNight ? UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1) : UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1) 
    }
}
