//
//  LoginViewModel.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/9.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper



final class LoginViewModel: BaseViewMoelType {
    
    init() {}
    
    var navigationTitle: Driver<String?> { return Driver.just(String.Local.login) }
    
    lazy var request: Observable<User> = { return self.actionRequestWith(api: .none)! }()
    
    
    
//    func actionRequestWith<T>(api: ActionAPI) -> Observable<T>? {
//
//        return createActionRequest(with: api) { (observer:AnyObserver<User>) in
//
//            HttpsManager.request(with: api).responseObject(completionHandler: ResponseHandler.handleObjectResponse_t(via: observer, success: {(user:Mappable) in
//
////                <#T##AnyObserver<(Mappable)>#>
//
//            })
//        }
//
//
//        return createActionRequest(with: api, creation: { (observer: AnyObserver<User>) in //T User
//
//            HttpsManager.request(with: api).responseObject(completionHandler: ResponseHandler.handleObjectResponse_t(via: observer, success: { (object: User) in //User
//
//                observer.onNext(object)
//                observer.onCompleted()
//
//            }))
//
//        }) as! Observable<T>?
//
//
//    }
    
    func setActionRequestAsMain(_ actionApi: ActionAPI) {
        self.request = actionRequestWith(api: actionApi)!
    }
    
    
    
    func actionRequestWith(api: ActionAPI) -> Observable<User>? {
        
        return createActionRequest(with: api, creation: { (observer: AnyObserver<User>) in
            
            HttpsManager.request(with: api).responseObject(completionHandler: ResponseHandler.handleObjectResponse_t(via: observer, success: { (object: User) in //User
                
                observer.onNext(object)
                observer.onCompleted()
                
            }))
            
        })
        
    }
                                                           
                
                                                           
                                                           
                                                           
    
                                                           
    
    
}
