//
//  DNSPageViewManager+Rx.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/23.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: DNSPageViewManager {
    var titleStyle: Binder<DNSPageStyle> {
        return Binder(self.base, binding: { (base, style) in
            guard let titleSuperView = base.titleView.superview else { return }
            base.titleView.removeFromSuperview()
            let newTitleView = DNSPageTitleView.init(frame: base.titleView.frame, style: style, titles: base.titles, currentIndex: base.titleView.currentIndex)
            base.titleView = newTitleView
            titleSuperView.addSubview(newTitleView)
            base.setupUI()
        })
    }
    
}
