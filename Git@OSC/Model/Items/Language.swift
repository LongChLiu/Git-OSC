//
//  Language.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/21.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

final class Language: Item {
    
    @objc dynamic var id: Int32 = 0
    @objc dynamic var parentID: Int32 = 0
    @objc dynamic var projectsCount: Int32 = 0
    @objc dynamic var name: String = "unknown"
    @objc dynamic var ident: String? = nil
    @objc dynamic var detail: String? = nil
    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()
    let order = RealmOptional<Int>()
    
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    
    func mapping(map: ObjectMapper.Map) {
        id <- map["id"]
        parentID <- map["parent_id"]
        projectsCount <- map["project_count"]
        name <- map["name"]
        ident <- map["ident"]
        detail <- map["detail"]
        order.value <- map["order"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
    }
    
    var contentHeight: CGFloat {
        return 44
    }
    
    func render(cell: RenderableCell) {
        cell.render(string: name)
    }
}
