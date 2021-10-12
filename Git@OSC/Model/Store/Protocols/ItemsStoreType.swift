//
//  ItemsStoreType.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/23.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import RxSwift
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

protocol ItemsStoreType: StoreType where T == ItemsType {
    var items: [O] { get set }
    var targetType: ItemsType { get }
    func saveItems(via userInfo: [ResponseKey: Any])
    init(type: ItemsType)
}

extension ItemsStoreType {
    static var itemsChangedNoti: Notification.Name {
        return Notification.Name(rawValue: "ItemsChanged")
    }
    
    
    func queryAllResults() -> Results<O>? {
        switch targetType {
        case .selfEvents:
            return self.query(via: NSPredicate(format: "authorId = %ld", CurrentUserManger.id), sortedKey: "createdDate", ascending: false)
        default: return nil
        }
    }
    
    func queryAllItems(limited: Int = 20) -> [O]? {
        switch targetType {
        case .featuredProjs:
            return self.query(via: NSPredicate(format: "featuredIndex != nil"), sortedKey: "featuredIndex").toArray(limited: limited)
        case .popularProjs:
            return self.query(via: NSPredicate(format: "popularIndex != nil"), sortedKey: "popularIndex").toArray(limited: limited)
        case .latestProjs:
            return self.query(via: NSPredicate(format: "latestIndex != nil"), sortedKey: "latestIndex").toArray(limited: limited)
        case .languagedProjs(_, let language):
            return self.query(via: NSPredicate(format: "languageIndex != nil && language = %@", language), sortedKey: "languageIndex").toArray(limited: limited)
        case .userEvents(let id):
            return self.query(via: NSPredicate(format: "authorId = %ld", id), sortedKey: "createdDate", ascending: false).toArray(limited: limited)
        case .selfEvents:
            return self.query(via: NSPredicate(format: "authorId = %ld", CurrentUserManger.id), sortedKey: "createdDate", ascending: false).toArray(limited: limited)
        case .userProjs(let id):
            return self.query(via: NSPredicate(format: "owner.id = %ld", id), sortedKey: "createdAt", ascending: true).toArray(limited: limited)
        case .staredProjs(let id):
            return UserStore(type: .user(id)).item?.startedProjects.toArray(limited: 20) as? [Self.O]
        case .watchedProjs(let id):
            return UserStore(type: .user(id)).item?.watchedProjects.toArray(limited: 20) as? [Self.O]
        default: return nil
        }
    }
    
    
    
    //MARK:- 网络请求
    func request(via param: [String: Any]?, uuid: UUID, observer: AnyObserver<()>) {
        HttpsManager.request(with: targetType, parameters: param).responseArray(completionHandler:
            ResponseHandler.handlerArrayResponse(via: observer, target: self.targetType, success: { [weak self] (newItems: [O]) in
                self?.handle(newItems: newItems, via: param, uuid: uuid)
                //发送完成事件避免资源一直被占用
                observer.onCompleted()
        }))
    }
    
    
    
    
    //MARK:- 网络请求
    func request_with_header(via param: [String: Any]?, uuid: UUID, observer: AnyObserver<()>) {
        
        HttpsManager.request_by_header(with: targetType, parameters: param).responseArray(completionHandler:ResponseHandler.handlerArrayResponse(via: observer, target: self.targetType, success: { [weak self] (newItems: [O]) in
                    
            self?.handle(newItems: newItems, via: param, uuid: uuid)
            //发送完成事件避免资源一直被占用
            observer.onCompleted()
        
        }))
   
    }
    
    
    
    
    //MARK:- handle

    
    func handle(newItems: [O], via param: [String: Any]?, uuid: UUID, sendNoti: Bool = true) {
        var userInfo: [ResponseKey: Any] = [.tragetType: self.targetType, .identity: uuid]
        //若参数存在page
        if let page = param?["page"] as? Int {
            var reason: ChangeReason
            if page == 1 {
                self.items = newItems
                reason = .request
            } else {
                self.items.append(contentsOf: newItems)
                reason = .loadMore
            }
            userInfo[.changeReason] = reason
        }
        else {
            userInfo[.changeReason] = ChangeReason.request
            self.items = newItems
        }
        //交由具体的StoreClasses实现持久化存储
        self.saveItems(via: userInfo)
        if sendNoti {
            NotificationCenter.default.post(name: Self.itemsChangedNoti, object: self
                .items, userInfo: userInfo)
        }
    }
    

}


