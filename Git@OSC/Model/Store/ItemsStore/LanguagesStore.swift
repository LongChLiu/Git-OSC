//
//  LanguagesStore.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/21.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

final class LanguagesStore: ItemsStoreType {

    typealias O = Language
    
    var items: [Language] = []
    
    var targetType: ItemsType
    
    func saveItems(via userInfo: [ResponseKey : Any]) {
        
    }
    
    init(type: ItemsType) {
        self.targetType = type
        self.items = self.queryAllItems() ?? []
    }
}
