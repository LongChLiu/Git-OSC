//
//  BaseViewMoelType.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/30.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseViewMoelType: AnyObject {
    
    associatedtype E
    
    var errorViewConfig: Driver<(Bool, (String?, UIImage?))> { get }
    
    var textHUDConfig: Driver<(Bool, String?)> { get }
    
    var navigationTitle: Driver<String?> { get }
    
    /// request是指控制器在window显示后默认产生的网络请求数据流
    var request: Observable<(E)> {get set}
    
    ///actionRequest是指与UI交互产生的次要网络请求数据流
    func actionRequestWith<T>(api: ActionAPI) -> Observable<T>?
}

extension BaseViewMoelType {
    
    func actionRequestWith<T>(api: ActionAPI) -> Observable<T>? { return nil }
    
    var errorViewConfig: Driver<(Bool, (String?, UIImage?))> {
        return request.asErrorViewConfig()
    }
    
    var textHUDConfig: Driver<(Bool, String?)> {
        return request.asTextHUDConfig()
    }
    
    func setActionRequestAsMain(_ actionApi: ActionAPI) {
        
//        self.request = actionRequestWith(api: actionApi)
        
    }
    
    func createActionRequest<T>(with api: ActionAPI, creation: @escaping (AnyObserver<T>)->() ) -> Observable<T>? {
        switch api {
        case .none: return Observable.error(RequestError.requestFailed(nil))
        default: return Observable<T>.create({ (observer) -> Disposable in
            creation(observer)
            return Disposables.create()
        }).share(replay: 1)
    }
        
    }
}
