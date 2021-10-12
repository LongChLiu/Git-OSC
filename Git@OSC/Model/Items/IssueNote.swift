//
//  IssueNote.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/25.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

final class IssueNote: Item {
    
    @objc dynamic var id: Int64 = 0
    @objc dynamic var authorName: String? = nil
    @objc dynamic var authorId: Int64 = 0
    @objc dynamic var portraitUrl: String? = nil
    @objc dynamic var body: String?        = nil
    @objc dynamic var createdDate: Date = Date()
    
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    
    
    var flattenBody: String? {
        return body?.flattenHtml.trimmingCharacters(in: .newlines)
    }
    
    func mapping(map:  ObjectMapper.Map) {
        id <- map["id"]
        authorId <- map["author.id"]
        body <- map["body"]
        authorName <- map["author.name"]
        portraitUrl <- map["author.new_portrait"]
        createdDate <- (map["created_at"], ISO8601DateTransform())

    }
    
    var contentHeight: CGFloat {
        let nameHeight = authorName?.height(with: UIFont.middle.normal, maxWidth: .cellMaxWidth(withPortrait: true))
        let bodyHieght = flattenBody?.height(with: UIFont.middle.normal, maxWidth: .cellMaxWidth(withPortrait: true))
        return (nameHeight ?? 0) + (bodyHieght ?? 0) + 24
}
    
    func render(cell: RenderableCell) {
        cell.render(imageURL: portraitUrl)
        cell.render(strings: authorName, flattenBody, createdDate.toRelative())
    }
}
