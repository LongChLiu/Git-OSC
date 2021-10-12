//
//  DNSPageView.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/8.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation


extension DNSPageStyle {
    
    static var custom: DNSPageStyle {
        let style = DNSPageStyle()
        style.isShowBottomLine = true
        style.titleColor = .normalText
        style.titleSelectedColor = .theme
        style.bottomLineColor = .theme
        style.titleViewBackgroundColor = .normalBackgroud
        style.contentViewBackgroundColor = .normalBackgroud
        return style
    }

    static var navigationTitle: DNSPageStyle {
        let style = DNSPageStyle()
        style.isShowBottomLine = true
        style.titleColor = .themeTextUnselected
        style.titleSelectedColor = .white
        style.bottomLineColor = .white
        style.titleViewBackgroundColor = .clear
        style.contentViewBackgroundColor = .normalBackgroud
        return style
    }
    
}
