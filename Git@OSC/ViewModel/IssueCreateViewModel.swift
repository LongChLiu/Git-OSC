//
//  IssueCreateViewModel.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/30.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class IssueCreateViewModel: BaseViewMoelType {
    
    var navigationTitle: Driver<String?> {
        return Driver.just("创建Issue")
    }
    
    lazy var request: Observable<String> = { return self.actionRequestWith(api: .none)! }()
    
    init() {}
    
    func actionRequestWith<T>(api: ActionAPI) -> Observable<T>? {
        
        return createActionRequest(with: api, creation: { (observer: AnyObserver<T>) in //String
            HttpsManager.request(with: api).responseString(completionHandler: ResponseHandler.handleResponseResult(observer: observer, target: api, success: { (_) in
                observer.onNext("创建Issus成功" as! T)
                observer.onCompleted()
            }))
        }) as! Observable<T>?
        
    }
}
