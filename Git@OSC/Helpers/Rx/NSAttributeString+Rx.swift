//
//  NSAttributeString+Rx.swift
//  Git@OSC
//
//  Created by strayRed on 2019/1/11.
//  Copyright © 2019 Red. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: NSMutableAttributedString {
    var textAttributes: Binder<TextAttributes> {
        return Binder<TextAttributes>.init(base) { $0.addAttributes($1) }
    }
}
