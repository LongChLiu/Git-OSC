//
//  Bindable.swift
//  Git@OSC
//
//  Created by strayRed on 2019/6/2.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift


protocol Bindable {
    var disposeBag: DisposeBag { get }
}

extension Bindable where Self: NetAccessableControllerType {
    /// 网络请求相关的视图绑定
    func bindRequestViews() {
        let viewModel = self.viewModel
        if let self = self as? TextHUDPresentable & UIViewController {
            viewModel.textHUDConfig.drive(self.textHUD.rx.textConfig).disposed(by: disposeBag)
        }
        if let self = self as? ErrorViewPresentable & UIViewController & Bindable {
            viewModel.errorViewConfig.drive(self.errorView.rx.config).disposed(by: disposeBag)
        }
        if let self = self as? IndicatorPresentable & UIViewController {
            viewModel.request.mapAsVoid().bind(to: self.indicator.rx.hide).disposed(by: disposeBag)
        }
    }
}
