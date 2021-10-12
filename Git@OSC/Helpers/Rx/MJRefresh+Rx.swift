//
//  MJRefresh.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/15.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


extension Reactive where Base: MJRefreshComponent {
    
    //正在刷新事件
    var refreshing: ControlEvent<()> {
        let source = Observable<()>.create {[ weak base = self.base ] (observer) in
            base?.refreshingBlock = {
                observer.onNext(())
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    var endRefreshing: AnyObserver<()> {
        return AnyObserver(eventHandler: { [ weak base = self.base ] (event) in
            //因为可能会有error所以不用Binder
            switch event {
            case .error(let error):
                switch (error as! RequestError) {
                case .noData(_):
                    //处理没有数据的错误
                    if let footer = base as? MJRefreshAutoNormalFooter {
                        footer.setTitle(String.Local.noMoreData, for: .noMoreData)
                        footer.state = .noMoreData
                    }
                    else { base?.endRefreshing() }
                    return
                default: break
                }
            default: break
            }
            base?.endRefreshing()
        })
    }
}


