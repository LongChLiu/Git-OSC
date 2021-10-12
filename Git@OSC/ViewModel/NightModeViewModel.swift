//
//  NightModeViewModel.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/21.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class NightModeViewModel {
    
   private let bag = DisposeBag()
    
    static let shared = NightModeViewModel()
    
    let normalBackgroud = BehaviorSubject<UIColor>(value: .normalBackgroud)
    
    let deepBackgroud = BehaviorSubject<UIColor>(value: .deepBackgroud)
    
    let normalTextColor = BehaviorSubject<UIColor>(value: .normalText)
    
    let selectedColor   = BehaviorSubject<UIColor>(value: .selected)
    
    let themeColor      = BehaviorSubject<UIColor>(value: .theme)
    
    
    let pageViewStyle   = BehaviorSubject<DNSPageStyle>(value: .custom)
    
    
    private init() {
        CurrentUserManger.isNightMode.bind { (_) in
            self.normalBackgroud.onNext(.normalBackgroud)
            self.deepBackgroud.onNext(.deepBackgroud)
            self.normalTextColor.onNext(.normalText)
            self.selectedColor.onNext(.selected)
            self.pageViewStyle.onNext(DNSPageStyle.custom)
            
        }.disposed(by: bag)
    }
}
