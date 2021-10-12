//
//  IndicatorPresentable.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/21.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation

private var associatedKey = "IndicatorView"


enum IndicatorBackgroundStyle {
    case translucent
    case clear
    case normal
}

protocol IndicatorPresentable: DNSPageEventHandleable { }

extension IndicatorPresentable where Self: UIViewController  {
    var indicator: MBProgressHUD {
        get {
            return castOrFatalError(objc_getAssociatedObject(self, &associatedKey))
        }
        set {
            objc_setAssociatedObject(self, &associatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //optinal getter
    private var _indicator: MBProgressHUD? {
        get {
            return objc_getAssociatedObject(self, &associatedKey) as? MBProgressHUD
        }
    }
    
    func contentViewWillAppear() {
        if let indicator = _indicator {
            for subView in indicator.bezelView.subviews {
                if let subView = subView as? UIActivityIndicatorView {
                    subView.isHidden = false
                    subView.startAnimating()
                }
            }
        }
    }
    

    func setupIndicatorWith(backgroundStyle: IndicatorBackgroundStyle, showNow: Bool = false) {
        indicator = MBProgressHUD.showAdded(to: view, animated: false)
        if !showNow {
            indicator.isHidden = true
        }
        
        indicator.mode = .indeterminate
        switch backgroundStyle {
        case .clear: break
        case .normal:
            indicator.backgroundView.backgroundColor = .normalBackgroud
        case .translucent:
            indicator.backgroundView.backgroundColor = .lucidBlack
        }
    }
}




