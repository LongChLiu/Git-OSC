//
//  NormalViewModelType.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/14.
//  Copyright © 2018 Git@OSC. All rights reserved.
//


import Foundation
import ObjectMapper
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON




/// 遵循MVVM设计模式的ViewModel
protocol NormalViewModelType: BaseViewMoelType where E == () {
    
    associatedtype S: StoreType
    
    var store: S { get }

    /// 用来保证ViewModel和其接受的Notification一一对应
    var uuid: UUID { get }
    
    /// 网络请求的参数
    var requestParam: [String: Any]? { get set }
    
    var isLocalDataExistd: Driver<Bool> { get }
    
    func reset(requestParam: [String: Any]?)
    
}

extension NormalViewModelType {
    
    /// 默认的参数，用于给参数的存储属性赋初值
    var defaultParam: [String: Any]? {
        return store.targetType.parameters
    }
    
    var navigationTitle: Driver<String?> {
        return Driver.just(self.store.targetType.title)
    }
    
    func request(via param: [String: Any]?) -> Observable<()> {
        return Observable<()>.create { [weak self] (observer) in
            
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            //model持有网络
            self.store.request(via: param, uuid: self.uuid, observer: observer)
            
            return Disposables.create()
            
        }
    }
    
    ///获取网络请求的序列
    func requestObservable() -> Observable<()> {
        let paramaters = requestParam == nil ? defaultParam : requestParam
        return request(via: paramaters).share(replay: 1)
    }
    

}

