//
//  UITabBar+Rx.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/23.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UITabBar {
    var barTintColor: Binder<UIColor> {
        return Binder<UIColor>.init(base) { $0.barTintColor = $1 }
    }
}
