//
//  ProjectStore.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/19.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RealmSwift

final class ProjectStore: ItemStoreType {
    
    
    var item: Project? = nil
    
    typealias O = Project
    
    var targetType: ItemType
    
    func saveItem(via userInfo: [ResponseKey : Any]) {  }
    
    init(type: ItemType, item: Project?) {
        self.targetType = type
        self.item = item
    }
    
    
    
}
