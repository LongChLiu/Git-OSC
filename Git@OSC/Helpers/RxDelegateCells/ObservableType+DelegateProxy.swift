//
//  ObservableType+DelegateProxy.swift
//  SimpleTableViewController
//
//  Created by Suyeol Jeon on 6/29/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableType {
    func subscribeForObject(binding: @escaping (Element) -> Void) -> Disposable {
//        let proxy = P.proxy(for: object)
//        //设置ForwardToDelegate
//
//        P.installForwardDelegate(delegate, retainDelegate: true, onProxyForObject: object)
//
//        //proxy.setForwardToDelegate(delegate, retainDelegate: true)
//        let disposable = Disposables.create(with: {
//            //销毁ForwardToDelegate
//            proxy.setForwardToDelegate(nil, retainDelegate: true)
//        })
        //subscription
        let subscription = self.asObservable()
            .concat(Observable.never()) // prevents delegate from being deallocated
            .subscribe { event in
                MainScheduler.ensureExecutingOnScheduler()
                switch event {
                case .next(let element):
                    binding(element)
                case .error(_): break
                case .completed: break
                }
        }
        return subscription
    
    }

}
