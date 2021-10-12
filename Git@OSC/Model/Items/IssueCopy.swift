//
//  IssueCopy.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/26.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

struct IssueCopy: RenderableObject {
    
    let id: Int64
    let iId: Int64
    let projectId: Int64
    let descriptionHtml: String
    let authorName: String
    let createdDate: Date
    let title: String
    let portraitUrl: String
    
    init(issue: Issue) {
        id = issue.id
        iId = issue.iId
        projectId = issue.projectId
        descriptionHtml = issue.descriptionHtml
        authorName = issue.authorName
        createdDate = issue.createdDate
        title = issue.title
        portraitUrl = issue.portraitUrl
    }
    
    var discriptionString: NSAttributedString {
        let fontAttribute = TextAttributes().font(UIFont.small.normal)
        let baseString = NSMutableAttributedString(string: String(format: "在%@创建该问题", createdDate.toString(.date(.medium))), attributes: fontAttribute.foregroundColor(.normalText))
        let nameString = NSAttributedString.init(string: authorName, attributes: fontAttribute.foregroundColor(.theme))
        baseString.insert(nameString, at: 0)
        return baseString
    }
    
    var contentHeight: CGFloat {
        let titleHeight = title.height(with: UIFont.middle.normal, maxWidth: .cellMaxWidth(withPortrait: false))
        let avatarHeight: CGFloat = 20
        let htmlHeight: CGFloat = 0
        return titleHeight + avatarHeight + htmlHeight + 18
    }
    
    func render(cell: RenderableCell) {
        cell.render(html: descriptionHtml)
        cell.render(imageURL: portraitUrl)
        cell.render(attributedString: discriptionString)
        cell.render(string: title)
    }
    
    
}
