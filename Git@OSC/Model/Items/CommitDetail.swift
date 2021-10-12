//
//  CommitDetail.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/24.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class CommitDetail: Item {
    @objc dynamic var deletedFile : Int = 0
    @objc dynamic var fileNew     : Int = 0
    @objc dynamic var renamedFile : Int = 0
    @objc dynamic var pathNew: String = ""
    @objc dynamic var pathOld: String = ""
    @objc dynamic var diff: String = ""
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    
    func mapping(map: ObjectMapper.Map) {
        deletedFile <- map["deleted_file"]
        fileNew <- map["new_file"]
        renamedFile <- map["renamed_file"]
        pathNew <- map["new_path"]
        pathOld <- map["old_path"]
        diff <- map["diff"]
    }
    
}

extension CommitDetail {
    var contentHeight: CGFloat {
        let diffHeight = "diff".height(with: UIFont.middle.normal, maxWidth: CGFloat.cellMaxWidth(withPortrait: false))
        let pathHeight = "pathNew".height(with: UIFont.small.normal, maxWidth: CGFloat.cellMaxWidth(withPortrait: false))
        return diffHeight + pathHeight + 24
    }
    
    func render(cell: RenderableCell) {
        cell.render(strings: diff, pathNew)
    }
    
    
}
