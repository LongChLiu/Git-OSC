//
//  UIView+Rx.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/21.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    var hide: AnyObserver<()> {
        return AnyObserver<()>.init(eventHandler: { [weak base = self.base] (event) in
            base?.isHidden = true
        })
    }
    var show: AnyObserver<()> {
        return AnyObserver<()>.init(eventHandler: { [weak base = self.base] (event) in
            base?.isHidden = false
        })
    }
    var backgroundColor: Binder<UIColor> {
        return Binder<UIColor>.init(base, binding: { (base, color) in
            base.backgroundColor = color
        })
    }
}
