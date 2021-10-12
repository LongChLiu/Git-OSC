//
//  UILabel+Rx.swift
//  Git@OSC
//
//  Created by strayRed on 2019/1/10.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    var textColor: Binder<UIColor> {
        return Binder<UIColor>.init(base) { $0.textColor = $1 }
    }
}
