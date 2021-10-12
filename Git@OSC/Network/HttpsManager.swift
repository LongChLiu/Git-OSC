//
//  SessionManager.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/6.
//  Copyright © 2018 Git@OSC. All rights reserved.
//
import Foundation
import Alamofire


fileprivate let key_urlUpdateDic = "URLUpdateDictionary"

struct HttpsManager {
    /// 不自动产生缓存的SessionManager
    private static let defaultSession: Alamofire.Session = {
        let configuration = URLSessionConfiguration.ephemeral
        //更该其protocolClasses 才能拦截URLSession的网络请求
        configuration.protocolClasses = [HttpsURLProtocol.self]
        return Alamofire.Session(configuration: configuration)
    }()
    //https头
    private static var headers: Alamofire.HTTPHeaders {
        return Alamofire.HTTPHeaders(["User-Agent": userAgent])
    }
    
    private static var userAgent: String {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let IDFV = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return String.init(format: "git.OSChina.NET/git_%@/%@/%@/%@/%@", appVersion, UIDevice.current.systemName, UIDevice.current.systemVersion, UIDevice.current.model, IDFV)
    }
    
    static var urlUpdateDic: [String?: Date]? = {
        return UserDefaults.standard.dictionary(forKey: key_urlUpdateDic) as? [String : Date] ?? nil
    }()
    
    static func saveUpdateDic() {
        UserDefaults.standard.set(urlUpdateDic, forKey: key_urlUpdateDic)
    }
    
    static func request(with type: TargetType, parameters: [String: Any]? = nil) -> DataRequest {
        let param = parameters == nil ? type.parameters : parameters
//        return HttpsManager.defaultSession.request(type.url, method: type.method, parameters: param, headers: HttpsManager.headers)
        return HttpsManager.defaultSession.request(type.url, method: type.method, parameters: param)
    }
    
    
    static func request_by_header(with type: TargetType, parameters: [String: Any]? = nil) -> DataRequest {
        let param = parameters == nil ? type.parameters : parameters
        return HttpsManager.defaultSession.request(type.url, method: type.method, parameters: param, headers: HttpsManager.headers)
//        return HttpsManager.defaultSession.request(type.url, method: type.method, parameters: param)
    }
    
}


