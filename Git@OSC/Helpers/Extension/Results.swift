//
//  Results.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/28.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RealmSwift


extension Results {    
    func toArray(limited: Int) -> [Element] {
        var array = [Element]()
        var count = limited
        if self.count < limited {
            count = self.count
        }
        for i in 0..<count {
            array.append(self[i])
        }
        return array
    }
}

extension List {
    func toArray(limited: Int?) -> [Element] {
        var array = [Element]()
        var count = limited ?? self.count
        if self.count < count {
            count = self.count
        }
        for i in 0..<count {
            array.append(self[i])
        }
        return array
    }
}

