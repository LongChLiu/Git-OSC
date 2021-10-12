//
//  Enums.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/14.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case requestFailed(String?)
    case noData(String?)
    case parseFailed(String?)
}

extension RequestError: Equatable {
    static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        switch (lhs, rhs) {
        case (.requestFailed(_), requestFailed(_)): return true
        case (.noData(_), noData(_)): return true
        case (.parseFailed(_), parseFailed(_)): return true
        default: return false
        }
    }
}


enum FileType {
    case tree
    case blob
    case unknown
}

enum RegisteredViewType {
    case `class`
    case xib
}





