//
//  BranchsStore.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/22.
//  Copyright © 2019 Red. All rights reserved.
//

import Foundation

import Realm
import RealmSwift
import Alamofire


final class ProjectCommitsStore: ItemsStoreType {
    
    typealias O = ProjectCommit
    
    weak var realm: Realm? = Store.shared.realm
    
    var items: [ProjectCommit] = []
    
    var itemsType: ItemsType
    
    private var branchs = ["master"]
    
    func request(via param: [String : Any]?, method: HTTPMethod, uuid: UUID, observer: AnyObserver<()>) {
        
    }
    
    
    func saveItems(via userInfo: [ItemsKey : Any]) {
        if let changedReason = userInfo[ItemsKey.changeReason] as? ItemsChangeReason, changedReason == .request {
            //只更新第一页数据
            update(items: items)
        }
    }
    
    init(type: ItemsType) {
        self.itemsType = type
        self.items = self.queryAllItems() ?? []
    }
}
