//
//  UserStore.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/9.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


final class UserStore: ItemStoreType {
    
    var item: User?
    
    typealias O = User
    
    var targetType: ItemType
    
    func saveItem(via userInfo: [ResponseKey : Any]) {
        update(items: [item!])
    }
    

    
    init(type: ItemType) {
        self.targetType = type
        self.item = queryItem()?.first
    }
}
