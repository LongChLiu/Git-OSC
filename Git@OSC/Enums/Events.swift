//
//  Event.swift
//  Git@OSC
//
//  Created by strayRed on 2019/1/11.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

enum EventAction: Int {
    case created = 1
    case updated
    case closed
    case reopend
    case pushed
    case commented
    case merged
    case joined
    case left
    case forked = 11
    
    var actionAndIndex: (String, Int?) {
        switch self {
        case .created  : return (" 在项目  创建了 ", 5)
        case .closed   : return (" 关闭了项目  的 ", 7)
        case .reopend  : return (" 重新打开了项目  的 ", 9)
        case .pushed   : return (" 推送到了项目  的分支", 8)
        case .commented: return (" 评论了项目  的 ", 7)
        case .merged   : return (" 接受了项目  的 ", 7)
        case .joined   : return (" 加入了项目 ", nil)
        case .updated  : return (" 更新了项目 ", nil)
        case .left     : return (" 离开了项目 ", nil)
        case .forked   : return (" Fork了项目 ", nil)
        }
    }
}
