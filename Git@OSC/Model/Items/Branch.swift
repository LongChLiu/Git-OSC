//
//  Branch.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/22.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

import Realm
import RealmSwift
import ObjectMapper

final class Branch: Object, Mappable {
    @objc dynamic var name: String =  ""
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    func mapping(map: ObjectMapper.Map) {
        name <- map["name"]
    }
}
