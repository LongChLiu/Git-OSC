//
//  EventStore.swift
//  Git@OSC
//
//  Created by strayRed on 2019/1/11.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class EventsStore: ItemsStoreType {
    
    typealias O = Event

    var items: [Event] = []
    
    var targetType: ItemsType
    
    func saveItems(via userInfo: [ResponseKey : Any]) {
        if let changedReason = userInfo[ResponseKey.changeReason] as? ChangeReason, changedReason == .request {
            //只更新第一页数据
            update(items: items)
        }
    }
    
    init(type: ItemsType) {
        self.targetType = type
        self.items = self.queryAllItems() ?? []
    }
}
