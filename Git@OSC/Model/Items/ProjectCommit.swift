//
//  ProjectCommit.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/22.
//  Copyright © 2019 Git@OSC. All rights reserved.
//



import Foundation

import Realm
import RealmSwift
import ObjectMapper

final class ProjectCommit: Item {
    @objc dynamic var id: String = ""
    @objc dynamic var shortId: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var authorName: String = ""
    @objc dynamic var portrait: String? = nil
    @objc dynamic var createdAt: Date? = nil
    @objc dynamic var htmlUrl: String? = nil
    
    let projectId = RealmOptional<Int64>()
    var branches = List<String>()
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    
    func mapping(map: ObjectMapper.Map) {
        id <- map["id"]
        shortId <- map["short_id"]
        title <- map["title"]
        htmlUrl <- map["html_url"]
        authorName <- map["author_name"]
        portrait   <- map["author.new_portrait"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
    }
}

extension ProjectCommit {
    var contentHeight: CGFloat {
        let titleHeight = title.height(with: UIFont.middle.normal, maxWidth: CGFloat.screenWidth - 36 - 24)
        let nameHeight = " ".height(with: UIFont.middle.normal, maxWidth: CGFloat.screenWidth - 36 - 24)
        let timeHeight = " ".height(with: UIFont.small.normal, maxWidth: CGFloat.screenWidth - 36 - 24)
        return titleHeight + nameHeight + timeHeight + 32
    }
    
    func render(cell: RenderableCell) {
        cell.render(imageURL: portrait)
        cell.render(strings: authorName, title, createdAt?.toRelative())
    }
}

