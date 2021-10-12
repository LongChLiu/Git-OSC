//
//  IssueNotesStore.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/25.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

final class IssueNotesStore: ItemsStoreType {
    
    typealias O = IssueNote
    
    var items: [IssueNote] = []
    
    var targetType: ItemsType
    
    func saveItems(via userInfo: [ResponseKey : Any]) {
        
    }
    
    init(type: ItemsType) {
        self.targetType = type
    }
    

    
    
}
