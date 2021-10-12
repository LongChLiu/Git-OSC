//
//  PortraitTappable.swift
//  Git@OSC
//
//  Created by strayRed on 2019/6/2.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift

protocol PortraitTappable: class {
    
    typealias PortraitInfo = (Int64?, String?)
    
    var reuseableBag: DisposeBag { get }
    
    /// userID和userName
    var portraitInfo: PortraitInfo {get  set}
    
    var portraitButton: UIButton! { get }
    
}

extension PortraitTappable {
    //点击头像
    func tapPortrait(_ tap: @escaping ((Int64, String) -> ())) {
        self.portraitButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self, let id = self.portraitInfo.0, let name = self.portraitInfo.1 else { return }
            //执行闭包
            tap(id, name)
            }.disposed(by: reuseableBag)
    }
}
