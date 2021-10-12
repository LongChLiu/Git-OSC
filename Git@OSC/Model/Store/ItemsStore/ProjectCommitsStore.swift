//
//  BranchsStore.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/22.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

import Realm
import RealmSwift
import Alamofire
import RxSwift
import RxCocoa


final class ProjectCommitsStore: ItemsStoreType {
    
    typealias O = ProjectCommit

    var items: [ProjectCommit] = []
    
    var targetType: ItemsType
    
    //private var branches = List<String>()
    func request(via param: [String : Any]?, uuid: UUID, observer: AnyObserver<()>) {
        switch self.targetType {
        case .projectCommits(let projecId):
            //参数为nil请求branches和Commits
            if param == nil {
                requestBrachesAndCommits(via: projecId, uuid: uuid, observer: observer)
                return
            }
            
            //切换branches
            HttpsManager.request(with: targetType, parameters: param).responseArray(completionHandler: ResponseHandler.handlerArrayResponse(via: observer, target: self.targetType, success: { [weak self] (newCommits: [ProjectCommit]) in
                guard let self = self else { return }
                self.handle(newItems: newCommits, via: param, uuid: uuid, sendNoti: false)
                observer.onCompleted()
                }))
            
        default: observer.onCompleted()
        }
    }
    
    func requestBrachesAndCommits(via id: Int64, uuid: UUID, observer: AnyObserver<()>) {
        
        let branchesType = ItemsType.projectBanrches(id: id)
        
        HttpsManager.request(with: branchesType).responseArray(completionHandler: ResponseHandler.handlerArrayResponse(via: observer, target: self.targetType, success: { [weak self] (res: [Branch]) in
            
            guard let self = self else { return }
            //将branches转换为List
            let branches = List<String>()
            branches.append(objectsIn: res.map { $0.name })
            let param: [String : Any] = ["page": 1, "ref_name": branches[0]]
            HttpsManager.request(with: self.targetType, parameters: param).responseArray(completionHandler: ResponseHandler.handlerArrayResponse(via: observer, target: self.targetType, success: { [weak self] (newCommits: [ProjectCommit]) in
                //self?.branches = branches
                //将brnches赋值给第一个对象
                newCommits.first?.branches = branches
                self?.handle(newItems: newCommits, via: param, uuid: uuid, sendNoti: false)
                observer.onCompleted()
            }))
            
        }))
    }
    
    func saveItems(via userInfo: [ResponseKey : Any]) {
        if !realm.isInWriteTransaction {
            switch self.targetType {
            case .projectCommits(let id):
                realm.beginWrite()
                //设置projectId
                for i in self.items { i.projectId.value = id }
                do { try realm.commitWrite() } catch { return }
            default: return }
            if let changedReason = userInfo[ResponseKey.changeReason] as? ChangeReason, changedReason == .request {
                //只更新第一页数据
                update(items: self.items)
            }
        }
        NotificationCenter.default.post(name: ProjectCommitsStore.itemsChangedNoti, object: self
            .items, userInfo: userInfo)
    }
    
    
    
    init(type: ItemsType) {
        self.targetType = type
        self.items = self.queryAllItems() ?? []
    }
    

}
