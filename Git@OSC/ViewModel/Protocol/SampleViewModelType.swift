//
//  SampleViewModelType.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/29.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

///不存在model的ViewModel
protocol SampleViewModelType: BaseViewMoelType {

    associatedtype T: TargetType
    
    var targetType: T { get }
    
    func sampleRequestObservable() -> Observable<E>
    
    init(type: T)
    
}

extension SampleViewModelType {
    
    var navigationTitle: Driver<String?>  {
        return Driver.just(targetType.title)
    }
    
    func createSampleRequest<E>(with creation: @escaping (AnyObserver<E>)->() ) -> Observable<E> {
        return Observable<E>.create({ (observer) -> Disposable in
            creation(observer)
            return Disposables.create()
        }).share(replay: 1)
    }
}


