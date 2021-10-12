//
//  AppDelegate.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/8.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import Foundation
import MonkeyKing
import Alamofire



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?
    private let bag = DisposeBag()
    
    private func setupBar() {
        let bar = UINavigationBar.appearance()
        bar.isTranslucent = false
        bar.barTintColor = .theme
        bar.tintColor = .white
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func registerMonkeyKingAccount() {
        let wcAccount = MonkeyKing.Account.weChat(appID: ShareConfigs.WeChat.appID, appKey: ShareConfigs.WeChat.appKey, miniAppID: nil, universalLink: nil)
        MonkeyKing.registerAccount(wcAccount)
        
        let qqAccount = MonkeyKing.Account.qq(appID: ShareConfigs.QQ.appID, universalLink: nil)
        MonkeyKing.registerAccount(qqAccount)
        
        let wbAccount = MonkeyKing.Account.weibo(appID: ShareConfigs.Weibo.appID, appKey: ShareConfigs.Weibo.appKey, redirectURL: "http://sns.whalecloud.com/sina2/callback")
        MonkeyKing.registerAccount(wbAccount)
    }
    
    private func networkListening() {
        
        /****网络状态监听****/
        let netManager = NetworkReachabilityManager.init(host: "https://gitee.com")
        
        netManager?.startListening(onUpdatePerforming: {(status: NetworkReachabilityManager.NetworkReachabilityStatus) in
            
            switch status {
            case .notReachable:
                 mainWindow?.show(text: "网络不可用")
            case .reachable(.ethernetOrWiFi):
                print("网络可用 WIFI")
                mainWindow?.show(text: "网络可用 WIFI")
            case .reachable(.cellular):
                print("网络可用，移动流量")
                mainWindow?.show(text: "网络可用，移动流量")
            default:
                mainWindow?.show(text: "未知网络错误")
            }
            
            
        })
        
    
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupBar()
        
        registerMonkeyKingAccount()
        
        networkListening()
        
        URLCache.shared = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 10 * 1024 * 1024, diskPath: nil)
        
        URLProtocol.registerClass(HttpsURLProtocol.self)
        
        CurrentUserManger.isLogin.bind { [weak self] _ in
            
            self?.coordinator = Coordinator()
            self?.window = UIWindow(frame: UIScreen.main.bounds)
            self?.window?.rootViewController = self?.coordinator?.rootController
            self?.window?.makeKeyAndVisible()
            
        }.disposed(by: bag)
    
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        return false
    }

    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

