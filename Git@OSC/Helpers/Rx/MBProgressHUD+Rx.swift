//
//  UIView+Rx.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/30.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


extension Reactive where Base: MBProgressHUD {
    var textShow: Binder<String?> {
        return Binder<String?>(self.base, binding: { (base, str) in
            base.label.text = str
            base.show(animated: true)
            base.hide(animated: true, afterDelay: 0.7)
        })
    }
    
    var textConfig: Binder<(Bool, String?)> {
        return Binder<(Bool, String?)>(self.base, binding: { (base, tup) in
            if !tup.0 {
                base.label.text = tup.1
                base.show(animated: true)
                base.hide(animated: true, afterDelay: 0.7)
            }
        })
    }
    
//    var isHidden: Binder<Bool> {
//        return Binder<Bool>.init(self.base, binding: { (base, isHidden) in
//            if isHidden { base.hide(animated: false) }
//            else { base.show(animated: false) }
//        })
//    }
    
//    var indicatorShow: Binder<()> {
//        return Binder<()>.init(self.base, binding: { (base, _) in
//            base.show(animated: true)
//        })
//    }
    
//    var indicatorHide: AnyObserver<()> {
//        return AnyObserver<()>.init(eventHandler: { [weak base = self.base] (event) in
//            base?.hide(animated: false)
//        })
//    }
}
