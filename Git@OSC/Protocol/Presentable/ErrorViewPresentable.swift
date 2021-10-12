//
//  ErrorViewPresentable.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/21.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import UIKit

private var associatedKey = "ErrorView"
//MARK:- ErrorViewPresentable
protocol ErrorViewPresentable: class {}

extension ErrorViewPresentable where Self: UIViewController & Bindable {
    
    var errorView: ErrorView {
        set {
            
            objc_setAssociatedObject(self, &associatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return castOrFatalError(objc_getAssociatedObject(self, &associatedKey))
        }
        
    }
    
    func setupErrorView() {
        errorView = ErrorView()
        view.addSubview(errorView)
        errorView.rx.refreshing.startWith(()).bind(to: errorView.rx.hide).disposed(by: disposeBag)
        errorView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        NightModeViewModel.shared.normalBackgroud.bind(to: errorView.rx.backgroundColor).disposed(by: disposeBag)
    }
}

extension ErrorViewPresentable where Self: NetAccessable & UIViewController & Bindable & IndicatorPresentable {
    func setupErrorView() {
        errorView = ErrorView()
        view.addSubview(errorView)
        errorView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        NightModeViewModel.shared.normalBackgroud.bind(to: errorView.rx.backgroundColor).disposed(by: disposeBag)
        let refreshing = errorView.rx.refreshing.share(replay: 1)
        refreshing.startWith(()).bind(to: errorView.rx.hide).disposed(by: disposeBag)
        refreshing.bind(to: indicator.rx.show).disposed(by: disposeBag)
        errorView.refreshButton.rx.tap.bind { [weak self] (_) in self?.request() }.disposed(by: disposeBag)
   }
}

