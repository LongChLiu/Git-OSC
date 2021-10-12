//
//  Store.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/9.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Realm
import Foundation
import RealmSwift


final class Store {
    static let shared = Store()
    let realm: Realm
    private init() {
        Store.set(realmName: "gitosc")
        realm = try! Realm()
    }
    
    static func deleteRealm(with realm: Realm = Store.shared.realm) {
        if realm.isInWriteTransaction { return }
        autoreleasepool {
            do {
                try realm.write {
                    
                    realm.deleteAll()
                }
            } catch(_) { return }
        }
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs: [URL] = [
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                // 错误处理
            }
        }
    }
    
    private static func set(realmName: String) {
        
        var config = Realm.Configuration()
        // 使用默认的目录，但是请将文件名替换为用户名
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(realmName).realm")
    
        // 将该配置设置为默认 Realm 配置
        Realm.Configuration.defaultConfiguration = config
    }
}

