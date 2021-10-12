//
//  ActionApi.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/17.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

enum ActionAPI {
    case starProject(String)
    case unstarProject(String)
    case watchProject(String)
    case unwatchProject(String)
    case createIssue(proID: Int64, title: String, description: String)
    case login(email: String?, password: String?)
    case none
}
