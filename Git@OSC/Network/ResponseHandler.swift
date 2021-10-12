//
//  ResponseHandler.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/29.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SwiftyJSON
import RxSwift


struct ResponseHandler {
    static func handlerArrayResponse<T: Mappable>(via observer: AnyObserver<()>, target: TargetType, success: @escaping ([T]) -> ()) -> (DataResponse<[T],AFError>) -> Void {
        return { dataResponse in
            if let error = dataResponse.error {
                observer.onError(RequestError.requestFailed(error.localizedDescription))
                return
            }
            if let objects = dataResponse.value {
                objects.count == 0 ? observer.onError(RequestError.noData(target.noDataDescription)) : success(objects)
            } else {observer.onError(RequestError.noData(String.Local.noPermission))}
        }
    }
    
    static func handleObjectResponse<T: Mappable>(via observer: AnyObserver<()>, success: @escaping (T) -> ()) -> (DataResponse<T,AFError>) -> Void {
        return { dataResponse in
            if let error = dataResponse.error {
                observer.onError(RequestError.requestFailed(error.localizedDescription))
                return
            }
            
            if let code = dataResponse.response?.statusCode, !code.isSuccessCode {
                observer.onError(RequestError.requestFailed(code.statusCodeDescription))
                return
            }
            
            if let object = dataResponse.value { success(object) }
            else { observer.onError(RequestError.noData(String.Local.noPermission)) }
        }
        
    }
    
    static func handleObjectResponse_t<T: Mappable>(via observer: AnyObserver<(T)>, success: @escaping (T) -> ()) -> (DataResponse<T,AFError>) -> Void {
        return { dataResponse in
            if let error = dataResponse.error {
                observer.onError(RequestError.requestFailed(error.localizedDescription))
                return
            }
            
            if let code = dataResponse.response?.statusCode, !code.isSuccessCode {
                observer.onError(RequestError.requestFailed(code.statusCodeDescription))
                return
            }
            
            if let object = dataResponse.value { success(object) }
            else { observer.onError(RequestError.noData(String.Local.noPermission)) }
        }
        
    }
    
    
    static func handleResponseResult<O, T>(observer: AnyObserver<O>, target: TargetType, success: @escaping (T) -> ()) -> (DataResponse<T,AFError>) -> Void {
        return { dataResponse in
            if let error = dataResponse.error {
                observer.onError(RequestError.requestFailed(error.localizedDescription))
                return
            }
            if let value = dataResponse.value {
                success(value)
            }else {
                observer.onError(RequestError.noData(target.noDataDescription))
            }
        }
    }

    
    
}
