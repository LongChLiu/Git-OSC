//
//  Utilities.swift
//  Git@OSC
//
//  Created by strayRed on 2019/1/9.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation


extension NSRange {
    init(_ range: Range<Int>) {
        self = NSRange(location: range.lowerBound, length: range.count)
    }
    
    init(_ string: NSString) {
        self = NSRange(location: 0, length: string.length)
    }
}

extension NSMutableParagraphStyle {
    func clone() -> NSMutableParagraphStyle {
        let clone = NSMutableParagraphStyle()
        
        if #available(iOS 9.0, *) {
            clone.setParagraphStyle(self)
        } else {
            clone.cloneParagraphStyle(self)
        }
        
        return clone
    }
    
    fileprivate func cloneParagraphStyle(_ other: NSMutableParagraphStyle) {
        alignment              = other.alignment
        firstLineHeadIndent    = other.firstLineHeadIndent
        headIndent             = other.headIndent
        tailIndent             = other.tailIndent
        lineBreakMode          = other.lineBreakMode
        maximumLineHeight      = other.maximumLineHeight
        minimumLineHeight      = other.minimumLineHeight
        lineSpacing            = other.lineSpacing
        paragraphSpacing       = other.paragraphSpacing
        paragraphSpacingBefore = other.paragraphSpacingBefore
        baseWritingDirection   = other.baseWritingDirection
        lineHeightMultiple     = other.lineHeightMultiple
    }
}
