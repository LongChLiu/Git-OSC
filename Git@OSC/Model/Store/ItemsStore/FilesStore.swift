//
//  FilesStore.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/11.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class FilesStore: ItemsStoreType {
    
    typealias O = File
    
    var items: [File] = []
    
    var targetType: ItemsType
    
    func saveItems(via userInfo: [ResponseKey : Any]) {

        /*持久化存储--------未实现（直接使用URLCache更加方便）*/
    }
    
    init(type: ItemsType) {
        self.targetType = type
    }
    
    
}
