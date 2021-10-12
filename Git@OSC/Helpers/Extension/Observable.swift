//
//  Observale.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/29.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Observable {
    func catchErrorAsString() -> Driver<String?> {
        return self.asErrorViewConfig(hideIn: nil).map{ $0.1.0 }
    }
    
    func catchErrorAsStrAndImg() -> Driver<(String?, UIImage?)> {
        return self.asErrorViewConfig(hideIn: nil).map{ $0.1 }
    }
    
    func catchErrorAsBool(hideIn errors: [RequestError]? = nil) -> Driver<(Bool)> {
        return self.asErrorViewConfig(hideIn: errors).map{ $0.0 }
    }
    
    func asTextHUDConfig(hideIn errors: [RequestError]? = nil) -> Driver<(Bool, String?)> {
        return self.asErrorViewConfig(hideIn: errors).map { ($0.0, $0.1.0) }
    }
    
    
    ///BOOL是表示是否隐藏ErrorView
    func asErrorViewConfig(hideIn errors: [RequestError]? = nil) -> Driver<(Bool, (String?, UIImage?))> {
        return self.map{ (_) -> (Bool, (String?, UIImage?)) in
            //没有error隐藏,有error默认显示
            return (true, (nil, nil))}.asDriver(onErrorRecover: handleRequestError(hideIn: errors))
    }
    
     private func handleRequestError(hideIn errors: [RequestError]?) -> (Error) -> Driver<(Bool, (String?, UIImage?))> {
            return { error in
                //可根据不同的网络请求错误返回文字和图片
                let def = Driver<(Bool, (String?, UIImage?))>.just((true, (String.Local.unkownError, nil)))
                guard let error = error as? RequestError else { return def }
                
                let isHidden = errors?.contains(where: { error == $0 }) ?? false
                
                switch error {
                case .requestFailed(let str):
                    let description = str ?? String.Local.requestError
                    return Driver<(Bool, (String?, UIImage?))>.just((isHidden, (description, UIImage(named: "page_icon_network"))))
                case .noData(let str):
                    let description = str ?? String.Local.noMoreData
                    return Driver<(Bool, (String?, UIImage?))>.just((isHidden, (description, UIImage(named: "page_icon_empty"))))
                case .parseFailed(let str):
                    let description = str ?? String.Local.parseFailed
                    return Driver<(Bool, (String?, UIImage?))>.just((isHidden, (description, nil)))
                }
        }
    }
}


extension Observable {
    func mapAsVoid() -> Observable<Void> {
        return self.map { _ in }
    }
    func mapAsOptional() -> Observable<Element?> {
        return self.map { $0 as Element? }
    }
    func asOptionalDriver() -> Driver<Element?> {
        return self.mapAsOptional().asDriver(onErrorJustReturn: nil)
    }
}


