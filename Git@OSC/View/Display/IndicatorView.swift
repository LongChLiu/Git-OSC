//
//  IndicatorView.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/1.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: IndicatorView {
    var progress: Binder<CGFloat> {
        return Binder<CGFloat>.init(base, binding: { (base, progress) in
            if base.style == .progress {
                base.activityHUD.progress = Float(progress)
            }
        })
    }
}


class IndicatorView: UIView {
    let activityHUD = MBProgressHUD()
    
    var style: Style = .normal {
        willSet(newStyle) {
            setup(with: newStyle)
        }
    }
    
    enum Style {
        case normal
        case normalClear
        case progress
    }
    
    init() {
        super.init(frame: .zero)
        setup(with: style)
        addSubview(activityHUD)
        activityHUD.show(animated: true)
    }
    
    private func setup(with style: Style) {
        switch style {
        case .normal:
            activityHUD.mode = .indeterminate
            activityHUD.contentColor = .gray
            backgroundColor = .normalBackgroud
        case .normalClear:
            activityHUD.mode = .indeterminate
            activityHUD.contentColor = .gray
            backgroundColor = .clear
        case .progress:
            activityHUD.mode = .annularDeterminate
            activityHUD.contentColor = .theme
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
