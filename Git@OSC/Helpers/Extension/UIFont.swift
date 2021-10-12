//
//  UIFont.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/21.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit


struct FontGenre {
    private let size: CGFloat
    var blod: UIFont  { return UIFont.boldSystemFont(ofSize: self.size) }
    var normal: UIFont { return UIFont.systemFont(ofSize: self.size) }
    
    init(size: CGFloat) {
        self.size = size
    }
}
extension UIFont {
    static var large: FontGenre {
        return FontGenre(size: 16)
    }
    
    static var middle: FontGenre {
        return FontGenre(size: 15)
    }
    
    static var small: FontGenre {
        return FontGenre(size: 14)
    }
    static var tiny: FontGenre {
        return FontGenre(size: 12)
    }
}
