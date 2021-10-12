//
//  Int.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/14.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

extension Int {
    var statusCodeDescription: String {
        switch self {
        case 401:      return String.Local.loginError
        case 200, 201: return "OK"
        default:       return String.Local.requestError
        }
    }
    
    var isSuccessCode: Bool {
        return 200...201 ~= self
    }
}

extension UInt {
    var size: String {
        if self < 1024 {
            return String.init(format: "%dB", self)
        }
        else if self < 1024 * 1024 {
            return String.init(format: "%.2fK", (CGFloat(self)/1024))
        }
        else if self < 1024 * 1024 * 1024 {
            return String.init(format: "%.2fM", (CGFloat(self)/(1024 * 1024)))
        } else {
            return String.init(format: "%2fG", (CGFloat(self)/(1024 * 1024 * 1024)))
        }
    }
}
