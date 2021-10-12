//
//  Render.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/15.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import UIKit

protocol RenderableObject {
    var contentHeight: CGFloat { get }
    func render(cell: RenderableCell)
}

extension RenderableObject {
    var defaultHeight: CGFloat { return 44 }
}


protocol RenderableCell {
    func render(strings: String?...)
    func render(string: String?)
    func render(bool: Bool?)
    func render(bools: Bool?...)
    func render(imageURL: String?)
    func render(nums: Int32?...)
    func render(nums: Int64?...)
    func render(image: UIImage?)
    func render(html: String?)
    func render(attributedString: NSAttributedString?)
    func render(attributedStrings: NSAttributedString?...)
}

extension RenderableCell {
    func render(strings: String?...) {}
    func render(string: String?) {}
    func render(bool: Bool?) {}
    func render(bools: Bool?...) {}
    func render(imageURL: String?) {}
    func render(nums: Int32?...) {}
    func render(nums: Int64?...) {}
    func render(image: UIImage?) {}
    func render(html: String?) {}
    func render(attributedString: NSAttributedString?) {}
    func render(attributedStrings: NSAttributedString?...) {}
}


