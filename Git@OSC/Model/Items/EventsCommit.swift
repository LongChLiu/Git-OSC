//
//  EventsCommit.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/27.
//  Copyright © 2018 Git@OSC. All rights reserved.
//
import Foundation
import Realm
import RealmSwift
import ObjectMapper

final class EventsCommit: Object, Mappable {
    
    @objc dynamic var id: String?
    @objc dynamic var authorName: String?
    @objc dynamic var message: String?
    
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    func mapping(map: ObjectMapper.Map) {
        id <- map["id"]
        authorName <- map["author.name"]
        message <- map["message"]
    }
}
