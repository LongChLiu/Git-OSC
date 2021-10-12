//
//  ItemViewModelType.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/19.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ItemViewModelType: NormalViewModelType where S: ItemStoreType {
    var initItem: BehaviorRelay<S.O?> { get }
    var dataSource: Driver<S.O?> { get }
}

extension ItemViewModelType {
    /// 是否存在本地数据
    var isLocalDataExistd: Driver<Bool> {
        return Driver.just(()).withLatestFrom(initItem.asDriver()).map { $0 != nil }
    }
    
    /// 提示视图配置
    var errorViewConfig: Driver<(Bool, (String?, UIImage?))> {
        return Driver.combineLatest(isLocalDataExistd, request.catchErrorAsStrAndImg())
    }
    
    /// 提示文字配置
    var textHUDConfig: Driver<(Bool, String?)> {
        return Driver.combineLatest(isLocalDataExistd.map{!$0}, request.catchErrorAsString())
    }
    
    var itemValue: S.O? {
        return store.item
    }
    
    var changeObservable: Observable<S.O?> {
       return NotificationCenter.default.rx.notification(S.itemChangedNoti).filter { [weak self] noti in
            noti.userInfo?[ResponseKey.identity] as? UUID == self?.uuid
            }.map { $0.object as? S.O }
    }
    
    func dataSource() -> Driver<S.O?> {
        return self.initItem.asObservable().flatMapLatest { [unowned self] item in
            return Observable.just(item).concat(self.changeObservable) }.asDriver(onErrorJustReturn: nil)
    }
    
    func reset(requestParam: [String: Any]?) {
        self.requestParam = requestParam
        self.request = requestObservable()
    }
}
