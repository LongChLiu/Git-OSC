//
//  User.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/9.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper

final class User: Item {
    /// id
    @objc dynamic var id: Int64 = 0
    /// is_admin
    @objc dynamic var isAdmin: Bool = false
    /*-----optional------*/
    /// username
    @objc dynamic var userName: String? = nil
    /// name
    @objc dynamic var name: String? = nil
    /// bio
    @objc dynamic var bio: String? = nil
    /// blog
    @objc dynamic var blog: String? = nil
    /// created_at
    @objc dynamic var createdAt: Date? = nil
    /// new_portrait
    @objc dynamic var portrait: String? = nil
    /// email
    @objc dynamic var email: String? = nil
    /// private_token
    @objc dynamic var privateToken: String? = nil
    ///weibo
    @objc dynamic var weibo: String? = nil
    
    
    /// follow.followers
    let followers = RealmOptional<Int32>()
    /// follow.following
    let following = RealmOptional<Int32>()
    /// follow.starred
    let started = RealmOptional<Int32>()
    /// follow.watched
    let watched = RealmOptional<Int32>()
    
    
    var startedProjects = List<Project>()
    var watchedProjects = List<Project>()
    
   
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /*----------------------Mappable------------------------------*/
    
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    
    func mapping(map: ObjectMapper.Map) {
        id              <- map["id"]
        isAdmin         <- map["is_admin"]
        userName        <- map["username"]
        name            <- map["name"]
        bio             <- map["bio"]
        blog            <- map["blog"]
        createdAt       <- (map["created_at"], ISO8601DateTransform())
        portrait        <- map["new_portrait"]
        email           <- map["email"]
        weibo           <- map["weibo"]
        privateToken    <- map["private_token"]
        followers.value <- map["follow.followers"]
        following.value <- map["follow.following"]
        started.value   <- map["follow.starred"]
        watched.value   <- map["follow.watched"]
    }
    
    var contentHeight: CGFloat {
        return 44
    }
    
    func render(cell: RenderableCell) {        
    }
   
}


