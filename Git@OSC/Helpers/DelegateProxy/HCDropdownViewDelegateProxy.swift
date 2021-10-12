//
//  HCDropdownViewDelegateProxy.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/26.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxCocoa

final class HCDropdownViewDelegateProxy: DelegateProxy<HCDropdownView, HCDropdownViewDelegate>, DelegateProxyType, HCDropdownViewDelegate {
    
    init(dropdownView: HCDropdownView) {
         super.init(parentObject: dropdownView, delegateProxy: HCDropdownViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { HCDropdownViewDelegateProxy(dropdownView: $0) }
    }
    
    static func currentDelegate(for object: HCDropdownView) -> HCDropdownViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: HCDropdownViewDelegate?, to object: HCDropdownView) {
        object.delegate = delegate
    }
    
    
}
