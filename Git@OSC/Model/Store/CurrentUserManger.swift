//
//  CurrentUserManger.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/3.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Realm
import RealmSwift
import ObjectMapper
import SDWebImage

fileprivate enum Key: String {
    case isLogin   = "IsLogin"
    case userId    = "UserId"
    case token     = "PrivateToken"
    case nightMode = "NightMode"
    case portrait  = "Portrait"
    case email     = "Email"
    case password  = "Password"
    case currentUser = "CurrentUser"
}

class CurrentUserManger {
    
    static let isNightMode = BehaviorRelay(value: _isNightMode)
    
    static let isLogin = BehaviorRelay(value: _isLogin)
    
    static var id: Int64 {
        let integer: NSNumber =  castOrFatalError(UserDefaults.standard.object(forKey: Key.userId.rawValue))
        return integer.int64Value
    }
    
    static var currentUser: User {
        guard let json = UserDefaults.standard.object(forKey: Key.currentUser.rawValue) as? [String: Any], let user = Mapper<User>().map(JSON: json) else { fatalError() }
        return user
    }
    
    static var privateToken: String {
        return UserDefaults.standard.string(forKey: Key.token.rawValue) ?? ""
    }
    
    static var portraitURL: String {
        return UserDefaults.standard.string(forKey: Key.portrait.rawValue) ?? ""
    }
    
    static var loginInfo: (String?, String?) {
        let userDefaults = UserDefaults.standard
        return (userDefaults.string(forKey: Key.email.rawValue), userDefaults.string(forKey: Key.password.rawValue))
    }
    
    static private var _isLogin: Bool {
        return UserDefaults.standard.bool(forKey: Key.isLogin.rawValue)
    }
    
    static private var _isNightMode: Bool {
        if _isLogin == false {
            return false
        }
        return UserDefaults.standard.bool(forKey: Key.nightMode.rawValue + String(id))
    }
    
    static func cleanCache<O: ObservableType>(via disposeBag: DisposeBag) -> (_ source: O) -> Driver<String?> where O.Element == () {
        return { source in
            return Observable.create({ (observer) -> Disposable in
                source.subscribe(onNext: { (_) in
                    
                    DispatchQueue.global(qos: .background).async {
                        URLCache.shared.removeAllCachedResponses()
                        let realm = try! Realm()
                        Store.deleteRealm(with: realm)
                    }
                    
                    SDImageCache.shared.clearDisk {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                            observer.onNext("缓存清理完毕")
                            Store.shared.realm.refresh()
                        })
                    }
                    
                }).disposed(by: disposeBag)
                return Disposables.create()
            }).asDriver(onErrorJustReturn: nil)
        }
    }
    

    static func saveNightMode<O: ObservableType>() -> (_ source: O) -> Disposable where O.Element == Bool {
        return { source in
            source.bind(onNext: { (isNightMode) in
                CurrentUserManger.isNightMode.accept(isNightMode)
                UserDefaults.standard.set(isNightMode, forKey: Key.nightMode.rawValue + String(id))
            })
        }
    }
    
    
    
    static func saveAccountInfo<O: ObservableType>() -> (_ source: O) -> Disposable where O.Element == User {
        return { source in
            source.subscribe(onNext: { (user) in
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: Key.isLogin.rawValue)
                userDefaults.set(NSNumber(value: user.id), forKey: Key.userId.rawValue)
                userDefaults.set(user.privateToken, forKey: Key.token.rawValue)
                userDefaults.set(user.portrait, forKey: Key.portrait.rawValue)
                userDefaults.set(user.toJSON(), forKey: Key.currentUser.rawValue)
                isLogin.accept(true)
                isNightMode.accept(_isNightMode)
            })
        }
    }
    
    static func logout<O: ObservableType>() -> (_ source: O) -> Disposable where O.Element == () {
        return { source in
            source.bind(onNext: { (_) in
                
                let userDefaults = UserDefaults.standard
                userDefaults.set(false, forKey: Key.isLogin.rawValue)
                userDefaults.set(nil, forKey: Key.userId.rawValue)
                userDefaults.set(nil, forKey: Key.token.rawValue)
                userDefaults.set(nil, forKey: Key.portrait.rawValue)
                userDefaults.set(nil, forKey: Key.currentUser.rawValue)
                
                isLogin.accept(false)
                isNightMode.accept(false)
            })
            
        }
    }
    
    static func save(email: String?, password: String?) {
        UserDefaults.standard.set(email, forKey: Key.email.rawValue)
        UserDefaults.standard.set(password, forKey: Key.password.rawValue)
    }
    
}
