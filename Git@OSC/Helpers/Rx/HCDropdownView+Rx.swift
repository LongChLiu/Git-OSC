//
//  HCDropdownView+Rx.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/23.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: HCDropdownView {
    var contents: Binder<[String]> {
        return Binder<[String]>(base, binding: { (base, titles) in
            base.titles = titles
            base.images = titles.map { _ in return "projectDetails_fork" }
            base.menuRowHeight = 44
            base.menuTabelView.rowHeight = 44
            base.menuTabelView.frame = CGRect.init(x: CGFloat.screenWidth/2, y: 0, width: CGFloat.screenWidth/2, height: base.menuRowHeight * CGFloat(titles.count))
        })
    }
    
    var delegateProxy: HCDropdownViewDelegateProxy {
        return HCDropdownViewDelegateProxy.proxy(for: base)
    }
    var itemSelected: ControlEvent<String> {
        return ControlEvent<String>.init(events: delegateProxy.methodInvoked(#selector(HCDropdownViewDelegate.didSelectItem(atRow:))).map { values in self.base.dropTitles[values[0] as! Int] })
    }
}
