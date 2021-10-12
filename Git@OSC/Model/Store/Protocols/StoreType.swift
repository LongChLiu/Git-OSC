//
//  StoreType.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/11.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import RealmSwift
import RxSwift
import Alamofire

protocol StoreType: AnyObject {
    associatedtype O: Item
    associatedtype T: TargetType
    var targetType: T { get }
    
    func request(via param: [String: Any]?, uuid: UUID, observer: AnyObserver<()>)
    
//    func request_with_header(via param: [String: Any]?, uuid: UUID, observer: AnyObserver<()>)
}



extension StoreType {
    
    var realm: Realm {
        return Store.shared.realm
    }
    
    func object(of id: Int64) -> O? {
        return realm.object(ofType: O.self, forPrimaryKey: id)
    }
    
    func update(items: [O]) {
        if realm.isInWriteTransaction { return }
        do {
            //save
            try realm.write {
                realm.add(items, update: .modified)
                //realm.add(items, update: true)
            }
            
        } catch(_) { return }
    }
    
    func query(via predicate: NSPredicate, sortedKey: String? = nil, ascending: Bool = true) -> Results<O> {
        if let key = sortedKey {
            return realm.objects(O.self).filter(predicate).sorted(byKeyPath: key, ascending: ascending)
        }
        return realm.objects(O.self).filter(predicate)
    }
    
    
}
