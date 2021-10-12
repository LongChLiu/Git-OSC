//
//  Project.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/8.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper
import RxDataSources
import SwiftDate


final class Project: Item {
    ///id
    @objc dynamic var id: Int64 = 0
    ///public
    @objc dynamic var isPublic     : Bool = true
    ///issues_enabled
    @objc dynamic var issuesEnabled: Bool = true
    ///recomm
    @objc dynamic var isRecomm     : Bool = true
    
    //define
    //用于持久化存储的分类和排序
    let featuredIndex = RealmOptional<Int>()
    let popularIndex  = RealmOptional<Int>()
    let latestIndex   = RealmOptional<Int>()
    let languageIndex = RealmOptional<Int>()
    
    var defaultDescription: String {
        return String.Local.defaultDescription
    }
    var defaultLanguage: String {
        return String.Local.defaultLanguage
    }
    
    /*-----optional------*/
    ///owner
    @objc dynamic var owner             : User? = nil
    ///name
    @objc dynamic var name              : String? = nil
    ///description
    @objc dynamic var projectDescription: String? = nil
    ///default_branch
    @objc dynamic var defaultBranch     : String? = nil
    ///path_with_namespace
    @objc dynamic var namespace         : String? = nil
    ///created_at
    @objc dynamic var createdAt         : Date? = nil
    ///last_push_at
    @objc dynamic var lastPushAt        : Date? = nil
    ///language
    @objc dynamic var language          : String? = nil
    ///forks_count
    let forksCount = RealmOptional<Int32>()
    ///stars_count
    let starsCount = RealmOptional<Int32>()
    ///watches_count
    let watchesCount = RealmOptional<Int32>()
    ///stared
    let started = RealmOptional<Bool>()
    ///watched
    let watched = RealmOptional<Bool>()
    
    let starters = LinkingObjects(fromType: User.self, property: "startedProjects")
    let watchers = LinkingObjects(fromType: User.self, property: "watchedProjects")
    
    
    override static func primaryKey() -> String? {
    
        return "id"
    }
    
    /*----------------------Mappable------------------------------*/
    
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    
    func mapping(map: ObjectMapper.Map) {
        id                 <- map["id"]
        isPublic           <- map["public"]
        issuesEnabled      <- map["issues_enabled"]
        isRecomm           <- map["recomm"]
        owner              <- map["owner"]
        name               <- map["name"]
        projectDescription <- map["description"]
        defaultBranch      <- map["default_branch"]
        namespace          <- map["path_with_namespace"]
        //使用DateTransform转换为date类型
        createdAt          <- (map["created_at"], ISO8601DateTransform())
        lastPushAt         <- (map["last_push_at"], ISO8601DateTransform())
        language           <- map["language"]
        forksCount.value   <- map["forks_count"]
        starsCount.value   <- map["stars_count"]
        watchesCount.value <- map["watches_count"]
        started.value      <- map["stared"]
        watched.value      <- map["watched"]
    }
    
}

extension Project {
    func render(cell: RenderableCell) {
        let ownerName = owner?.name ?? ""
        let projectName = name ?? ""
        let fullName = ownerName + "/" + projectName
        //调用cell的render方法
        cell.render(string: name)
        cell.render(strings: fullName, projectDescription == "" ? defaultDescription : projectDescription , language ?? defaultLanguage, lastPushAt?.toRelative())
        cell.render(bools: isRecomm, isPublic, started.value, watched.value)
        cell.render(imageURL: owner?.portrait)
        cell.render(nums: forksCount.value, starsCount.value, watchesCount.value)
        cell.render(nums: self.owner?.id)
    }
    
    ///项目详细中nameCell的高度
    var nameCellHeight: CGFloat {
        return 36 + "".height(with: UIFont.middle.blod, maxWidth: .screenWidth) + 24
    }
    ///项目详细中descriptionCell的高度
    var descriptionCellHeight: CGFloat {
        let contentHeight: CGFloat = projectDescription?.height(with: UIFont.middle.normal, maxWidth: CGFloat.screenWidth - 16) ?? 0
        return 36 + contentHeight + 30 + 26
    }
    
    ///项目详细中basicInfoCell的高度
    var basicInfoCellHeight: CGFloat {
        return 24 + 20 + 18 * 2
    }
    
    /// 每个实例对应的cell高度
    var contentHeight: CGFloat {
        let space: CGFloat = 8 + 12 + 12 + 15 + 12
        let namespaceHeight: CGFloat = namespace?.height(with: UIFont.middle.blod, maxWidth: .screenWidth) ?? 0
        let contentHeight: CGFloat = projectDescription?.height(with: UIFont.middle.normal, maxWidth: CGFloat.screenWidth - 24 - 36) ?? 0
        return space + namespaceHeight + contentHeight
    }
}

extension Project {
    func index(of type: ItemsType) -> Int? {
        switch type {
        case .featuredProjs:
            return featuredIndex.value
        case .popularProjs:
            return popularIndex.value
        case .latestProjs:
            return latestIndex.value
        case .languagedProjs(lng: _):
            return languageIndex.value
        default: return nil
        }
    }
}
