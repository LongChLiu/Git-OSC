//
//  File.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/11.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper

final class File: Item {
    @objc private dynamic var type: String = ""
    @objc dynamic var id  : String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var mode: String? = nil
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    

    //define
    var fileType: FileType {
        switch type {
        case "tree":
            return FileType.tree
        case "blob":
            return FileType.blob
        default: return FileType.unknown
        }
    }
    
    var isCodeFile: Bool {
        return self.name.isCodeFileName
    }
    
    var isImageFile: Bool {
        return self.name.isImageFileName
    }
    
    /*----------------------Mappable------------------------------*/
    
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    
    func mapping(map: ObjectMapper.Map) {
        id   <- map["id"]
        mode <- map["mode"]
        name <- map["name"]
        type <- map["type"]
    }
}

extension File {
    var contentHeight: CGFloat {
        return 44
    }
    
    func render(cell: RenderableCell) {
        cell.render(string: name)
        switch fileType {
        case .blob:
            cell.render(image: UIImage(named: "file"))
        case .tree:
            cell.render(image: UIImage(named: "folder"))
        default: return
        }
    }
    
}

extension File {
    //KEYS FOR INFO
    static let fileName = "fileName"
    static let currentPath  = "currentPath"
    static let language = "language"
    static let namespace = "namespace"
    static let projectId = "projectId"
}
