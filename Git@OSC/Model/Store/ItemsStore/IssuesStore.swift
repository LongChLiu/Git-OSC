//
//  IssuesStore.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/23.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxCocoa

final class IssuesStore: ItemsStoreType {

    typealias O = Issue
    
    var items: [Issue] = []
    
    var targetType: ItemsType
    
    func saveItems(via userInfo: [ResponseKey : Any]) {}
    
    init(type: ItemsType) {
        self.targetType = type
    }
    
}


