//
//  ItemsViewModelType.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/22.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire

protocol ItemsViewModelType: NormalViewModelType where S: ItemsStoreType {
    var initItems: BehaviorRelay<[S.O]> { get }
    var page: BehaviorRelay<Int> { get }
    var loadMore: Observable<()> { get  set }
    ///数据源
    var dataSource: Driver<[S.O]> { get }
    
    var contents: Driver<[Section]> { get }
    
    var cellHeight: Driver<[[CGFloat]]> { get }

}

extension ItemsViewModelType {

    var cellHeight: Driver<[[CGFloat]]> {
        return contents.asCellHeights()
    }
    
    var itemsValue: [S.O] {
        return store.items
    }
        
    /// 是否存在本地数据
    var isLocalDataExistd: Driver<Bool> {
        return Driver.just(()).withLatestFrom(initItems.asDriver()).map { $0 != [] }
    }
    
    /// 提示视图配置
    var errorViewConfig: Driver<(Bool, (String?, UIImage?))> {
        return Driver.combineLatest(isLocalDataExistd, request.catchErrorAsStrAndImg())
    }
    
    /// 提示文字配置
    var textHUDConfig: Driver<(Bool, String?)> {
        return Driver.combineLatest(isLocalDataExistd.map{ !$0 }, request.catchErrorAsString())
    }
    
    func dataSource() -> Driver<[S.O]> {
        return self.initItems.asObservable().flatMapLatest { [unowned self] in
            Observable.just($0).concat(self.changeObservable) }.asDriver(onErrorJustReturn: [])
    }
    
    private var changeObservable: Observable<[S.O]>  {
        return NotificationCenter.default.rx.notification(S.itemsChangedNoti).filter { [weak self] noti in
            noti.userInfo?[ResponseKey.identity] as? UUID == self?.uuid
            }.map { [weak self] noti in
                guard let self = self, let changedReason = noti.userInfo?[ResponseKey.changeReason] as? ChangeReason else { return [] }
                switch changedReason {
                case .request : self.page.accept(2)
                case .loadMore: self.page.accept(self.page.value + 1)
                }
                return noti.object as? [S.O] ?? []
        }
    }
    

    
    var loadMoreParam: [String: Any]?  {
        var p = self.requestParam
        p?["page"] = page.value
        return p
    }
    
    func loadMoreObservable() -> Observable<()> {
        return Observable.just(()).withLatestFrom(page.asObservable()).flatMapLatest { [weak self] _ in
            self?.request(via: self?.loadMoreParam).share(replay: 1) ?? Observable.just(())
        }
    }
    
    func reset(requestParam: [String: Any]?) {
        self.requestParam = requestParam
        self.request = requestObservable()
        self.loadMore = loadMoreObservable()
    }
}

