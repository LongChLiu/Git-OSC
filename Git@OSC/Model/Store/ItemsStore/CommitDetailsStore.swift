//
//  CommitDetailsStore.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/24.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

import Realm
import RealmSwift
import RxSwift
import RxCocoa


final class CommitDetailsStore: ItemsStoreType {

    typealias O = CommitDetail
    
    var items: [CommitDetail] = []
    
    var targetType: ItemsType
    
    func saveItems(via userInfo: [ResponseKey : Any]) {
        //
    }
    
    init(type: ItemsType) {
        self.targetType = type
    }
    
    
    
    
}
