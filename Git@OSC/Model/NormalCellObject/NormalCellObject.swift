//
//  ProjectDetils.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/4.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation

struct NormalObject {
    var image: UIImage?
    var imageURL: String?
    var text: String?
    var attributedText: NSMutableAttributedString?
    
    init(image: UIImage? = nil, text: String? = nil, imageURL: String? = nil, attributedText: NSMutableAttributedString? = nil) {
        self.image = image
        self.text = text
        self.attributedText = attributedText
        self.imageURL = imageURL
    }
}

extension NormalObject: RenderableObject {
    var contentHeight: CGFloat {
        return 44
    }
    
    func render(cell: RenderableCell) {
        cell.render(string: text)
        cell.render(image: image)
        cell.render(imageURL: self.imageURL)
        if attributedText != nil { cell.render(attributedString: attributedText) }
    }
    

    
}
