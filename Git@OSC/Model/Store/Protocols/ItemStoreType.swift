//
//  ItemStoreType.swift
//  Git@OSC
//
//  Created by strayRed on 2019/1/20.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import Alamofire
import RealmSwift
import SwiftyJSON


protocol ItemStoreType: StoreType where T == ItemType {
    var item: O? { get set }
    var targetType: ItemType { get }
    func saveItem(via userInfo: [ResponseKey: Any])
}

extension ItemStoreType {
    static var itemChangedNoti: Notification.Name {
        return Notification.Name(rawValue: "ItemChanged")
    }
    

    func queryItem() -> Results<O>? {
        switch targetType {
        case .projsDetails(let id):
            return query(via: NSPredicate(format: "id = %ld", id))
        case .user(let id):
            return query(via: NSPredicate(format: "id = %ld", id))
        default: return nil
        }
    }
    
    func request(via param: [String: Any]?, uuid: UUID, observer: AnyObserver<()>) {
        HttpsManager.request(with: targetType, parameters: param).responseObject(completionHandler: ResponseHandler.handleObjectResponse(via: observer, success: { [weak self] (newItem: O) in
            guard let self = self else { return }
            let userInfo: [ResponseKey: Any] = [.identity: uuid, .changeReason: ChangeReason.request, .tragetType: self.targetType]
            self.item = newItem
            self.saveItem(via: userInfo)
            NotificationCenter.default.post(name: Self.itemChangedNoti, object: self.item, userInfo: userInfo)
            observer.onCompleted()
        }))
    }
    
}
