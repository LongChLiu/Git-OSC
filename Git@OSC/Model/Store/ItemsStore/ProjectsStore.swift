//
//  ProjectsSotre.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/9.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


final class ProjectsStore: ItemsStoreType {
    
    typealias O = Project
    
    var items: [Project] = []
    
    var targetType: ItemsType
    
    var realm: Realm? = Store.shared.realm //weak

    ///使用这个方法保留之前的index
    private func custom(item: Project, index: Int) {
        if let obj = object(of: item.id) {
            realm.beginWrite()
            if let v = obj.featuredIndex.value { item.featuredIndex.value = v }
            if let v = obj.popularIndex.value { item.popularIndex.value = v }
            if let v = obj.latestIndex.value { item.latestIndex.value = v }
            if let v = obj.languageIndex.value { item.languageIndex.value = v }
            try! realm.commitWrite()
        }
        switch targetType {
        case .featuredProjs: item.featuredIndex.value = index
        case .popularProjs: item.popularIndex.value = index
        case .latestProjs: item.latestIndex.value = index
        case .languagedProjs(_): item.languageIndex.value = index
        default: break
        }
        
    }
    //MARK: - Save
    ///定制的存储方法
    private func saveOrderedItems() {
        //本地没有数据存在
        if queryAllItems()?.count == 0 {
            var index = 0
            for item in items {
                custom(item: item, index: index)
                index += 1
            }
            update(items: items)
        }
        //本地存在数据
        else {
            var index = items.count - 1
            var diff  = 0
            var turn  = true
            var newItems = [Project]()
            //所有请求到的数据都是新数据（本地不存在）
            //取本地第一条数据的index-新数据的count作为差值
            if object(of: items[items.count - 1].id) == nil, let firstIndex = queryAllItems()?.first?.index(of: targetType) {
                diff = firstIndex - items.count
                turn = false
            }
            for _ in items {
                let item = items[index]
                //已经存在拥有序列的该类型数据(忽略，并计算新的index差)
                if turn, let obj = object(of: item.id), let storedIndex = obj.index(of: targetType) {
                    diff = storedIndex - index
                } else {
                    //不存在就新定制
                    custom(item: item, index: index + diff)
                    newItems.append(item)
                }
                index -= 1
            }
            update(items: newItems)
        }
    }
    
    private func saveNormalItems() {
        items.forEach { self.custom(item: $0, index: 0) }
        update(items: items)
    }
    
    private func saveOwnerdItems() {
        items.forEach { self.custom(item: $0, index: 0) }
        realm.beginWrite()
        let itemsList = List<Project>()
        itemsList.append(objectsIn: items)
        switch self.targetType {
        case .staredProjs(let id):
            let userStore = UserStore(type: .user(id))
            if let user = userStore.item {
                user.startedProjects = itemsList
                do { try realm.commitWrite() } catch { return }
                userStore.update(items: [user])
            }
        case .watchedProjs(let id):
            let userStore = UserStore(type: .user(id))
            if let user = userStore.item {
                user.watchedProjects = itemsList
                do { try realm.commitWrite() } catch { return }
                userStore.update(items: [user])
            }
        default: break
        }
    }
    
    func saveItems(via userInfo: [ResponseKey : Any]) {
        //只存储第一页的数据
        if let changedReason = userInfo[ResponseKey.changeReason] as? ChangeReason, changedReason == .request, !(realm?.isInWriteTransaction ?? false) {
            switch self.targetType {
            case .userProjs(_): saveNormalItems()
            case .staredProjs(_), .watchedProjs(_): saveOwnerdItems()
            case .latestProjs, .popularProjs, .featuredProjs, .languagedProjs(_, _):
                saveOrderedItems()
            default: break
            }
        }
    }
    
    //MARK:- 初始化
    init(type: ItemsType) {
        self.targetType = type
        self.items = self.queryAllItems() ?? []
    }
    
//    func item() {
//        ProjectsStore.init(type: .featuredProjs).queryAllItems()
//    }

}
