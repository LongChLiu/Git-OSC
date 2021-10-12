//
//  UITableView+Rx.swift
//  Git@OSC
//
//  Created by strayRed on 2019/1/10.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    var separatorColor: Binder<UIColor> {
        return Binder<UIColor>(base) { $0.separatorColor = $1 }
    }
}
