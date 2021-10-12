//
//  Issue.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/23.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

final class Issue: Item {
    @objc dynamic var id: Int64 = 0
    @objc dynamic var iId: Int64 = 0
    @objc dynamic var projectId: Int64 = 0
    @objc dynamic var descriptionHtml: String = ""
    @objc dynamic var authorName: String = "unknown"
    @objc dynamic var createdDate: Date = Date()
    @objc dynamic var title: String = ""
    @objc dynamic var portraitUrl: String = ""
    
    var info: String {
        return String(format: "#%lld by %@ - %@", iId, authorName, createdDate.toString(.date(.medium)))
    }
    
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    
    func mapping(map: ObjectMapper.Map) {
        id <- map["id"]
        iId <- map["iid"]
        descriptionHtml <- map["description"]
        authorName <- map["author.name"]
        createdDate <- (map["created_at"], ISO8601DateTransform())
        title <- map["title"]
        projectId <- map["project_id"]
        portraitUrl <- map["author.new_portrait"]
    }
}

extension Issue {
    
    static func creationParam(via api: ActionAPI) -> [String: Any] {
        switch api {
        case .createIssue(let projectID, let title, let description):
            return ["assignee": 0, "labels": NSNull(), "milestone": 0, "id": projectID, "title": title, "description": description]
        default: return [:]
        }
    }
    
    var contentHeight: CGFloat {
        let maxWith = CGFloat.cellMaxWidth(withPortrait: true)
        let titleHeight = " ".height(with: UIFont.middle.normal, maxWidth: maxWith)
        let infoHeight = " ".height(with: UIFont.small.normal, maxWidth: maxWith)
        return titleHeight + infoHeight + 24
    }
    
    func render(cell: RenderableCell) {
        cell.render(imageURL: portraitUrl)
        cell.render(strings: title, info, authorName)
        cell.render(nums: projectId)
        cell.render(html: descriptionHtml)
    }
    
    
}
