//
//  Event.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/27.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper

final class Event: Item {
    @objc dynamic var id: Int64 = 0
    ///public
    @objc dynamic var isPublic = true
    ///author.name
    @objc dynamic var authorName       = ""
    ///project.name
    @objc dynamic var projectName      = ""
    ///project.owner.name
    @objc dynamic var projectOwnerName = ""
    ///data.ref
    @objc dynamic var ref              = ""
    ///author_id
    @objc dynamic var authorId    : Int64 = 0
    ///data.total_commits_count
    @objc dynamic var commitsCount: Int = 0
    ///project_id
    @objc dynamic var projectId    : Int64 = 0
    ///created_at
    @objc dynamic var createdDate     : Date?   = nil
    ///updated_at
    @objc dynamic var updateDate      : Date?   = nil
    ///target_type
    @objc dynamic var targetType      : String? = nil
    ///events.pull_request.title
    @objc dynamic var pullRequestTitle: String? = nil
    ///events.issue.title
    @objc dynamic var issueTitle      : String? = nil
    ///events.note.note
    @objc dynamic var note            : String? = nil
    ///title
    @objc dynamic var title           : String?  = nil
    ///author.portrait
    @objc dynamic var portrait        : String?  = nil
    
    ///target_id
    let targetId       = RealmOptional<Int64>()
    ///action
    let action         = RealmOptional<Int>()
    ///events.pull_request.iid
    let pullRequestIID = RealmOptional<Int>()
    ///events.issue.iid
    let issueIID       = RealmOptional<Int>()
    
    var commits = List<EventsCommit>()

    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var targetTitle: String {
        guard let targetType = targetType else { return "" }
        if targetType == "PullRequest" { return pullRequestTitle ?? "" }
        if targetType == "Issue" { return issueTitle ?? "" }
        return ""
    }
    
    var eventTitle: String {
        if let prID = pullRequestIID.value { return "Pull Request #" + String(prID) }
        if let isuID = issueIID.value { return "Issue #" + String(isuID) }
        return ""
    }
    
    var eventContent: String {
        if let prTitle = self.pullRequestTitle { return prTitle }
        if let isuTitle = self.issueTitle { return isuTitle }
        return ""
    }
    
    /// 提交内容
    var commitsAttString: NSAttributedString {
        
        let idAttributes = TextAttributes().font(UIFont.small.normal).foregroundColor(.theme)
        
        let contentAttributes = TextAttributes().font(UIFont.small.normal).foregroundColor(.normalText)
        
        let commitsAttString = NSMutableAttributedString()
        let count = commitsCount > 2 ? 2 : commitsCount
        (0..<count).forEach { index in
            let commit = commits[index]
            guard let id = commit.id, let authorName = commit.authorName, let message = commit.message else { return }
            
            let commitId = NSAttributedString(string: String(id[...String.Index(utf16Offset: 9, in: id)]), attributes: idAttributes)
            let content = NSAttributedString(string: String(format: " %@ - %@ ", authorName, message), attributes: contentAttributes)
            commitsAttString.append(commitId)
            commitsAttString.append(content)
            
        }
        if commitsCount > 2 {
            commitsAttString.append(NSAttributedString(string: String(format: "\n... and %i more commits", commitsCount - 2), attributes: contentAttributes))
        }
        return commitsAttString
    }
    
    required convenience init?(map: ObjectMapper.Map) { self.init() }
    
    func mapping(map: ObjectMapper.Map) {
        id                   <- map["id"]
        isPublic             <- map["public"]
        authorId             <- map["author_id"]
        authorName           <- map["author.name"]
        commitsCount         <- map["data.total_commits_count"]
        createdDate          <- (map["created_at"], ISO8601DateTransform())
        updateDate           <- (map["updated_at"], ISO8601DateTransform())
        title                <- map["title"]
        targetId.value       <- map["target_id"]
        action.value         <- map["action"]
        pullRequestIID.value <- map["events.pull_request.iid"]
        issueIID.value       <- map["events.issue.iid"]
        pullRequestTitle     <- map["events.pull_request.title"]
        issueTitle           <- map["events.issue.title"]
        note                 <- map["events.note.note"]
        ref                  <- map["data.ref"]
        projectId            <- map["project.id"]
        projectName          <- map["project.name"]
        projectOwnerName     <- map["project.owner.name"]
        commits              <- (map["data.commits"], ListTransform<EventsCommit>())
        portrait             <- map["author.new_portrait"]
    }
    
}

extension Event {
    var contentHeight: CGFloat {
        let titleHeight: CGFloat = attributedTitle.string == "" ? 0 : attributedTitle.string.height(with: UIFont.middle.normal, maxWidth: CGFloat.screenWidth - 24 - 36)
        let contentHeight = attributedContent.string.height(with: UIFont.small.normal, maxWidth: CGFloat.screenWidth - 24 - 36 - 16)
        let space: CGFloat = attributedContent.string == "" ? 24 : 32 + 16 + 16
        return titleHeight + contentHeight + space
    }
    
    
    func render(cell: RenderableCell) {
        cell.render(attributedStrings: attributedTitle, attributedContent)
        cell.render(imageURL: portrait)
        cell.render(string: createdDate?.toRelative())
        //是否显示content的背景
        cell.render(bool: commitsCount > 0)
    }
    
        
    /// 标题
    var attributedTitle: NSAttributedString {
        let title = NSMutableAttributedString(string: authorName, attributes: TextAttributes().foregroundColor(.theme).font(UIFont.middle.blod))
        let themeAttributes = TextAttributes().foregroundColor(.theme).font(UIFont.middle.normal)
        let project = NSAttributedString(string: String(format: "%@ / %@", projectName, projectOwnerName), attributes: themeAttributes)
        guard let actionValue = self.action.value else { return NSAttributedString() }
    
        //actionString
        let action: NSMutableAttributedString
        //attributes
        let actionAttributes = TextAttributes().foregroundColor(UIColor.lightGray).font(UIFont.middle.normal)
    
        if let eventAction = EventAction(rawValue: actionValue) {
            action = NSMutableAttributedString(string: eventAction.actionAndIndex.0, attributes: actionAttributes)
            //需要插入projectName
            if let index = eventAction.actionAndIndex.1 {
                action.insert(project, at: index)
                //.pushed插入ref
                //其他则添加eventTitle
                eventAction == EventAction.pushed ? action.insert(NSAttributedString(string: (ref as NSString).lastPathComponent, attributes: themeAttributes), at: action.length - 2) : action.append(NSAttributedString(string: eventTitle, attributes: themeAttributes))
            }
        }
        else {
            action = NSMutableAttributedString(string: " 更新了动态", attributes: actionAttributes)
        }
        title.append(action)
        return title
    }
    
    /// 内容
    var attributedContent: NSAttributedString {
        if commitsCount > 0 { return commitsAttString }
        guard let action = action.value, let eventAction = EventAction.init(rawValue: action) else { return NSAttributedString() }
        let contentAttributes = TextAttributes().font(UIFont.small.normal).foregroundColor(.normalText)
        switch eventAction {
        case .created:
            return NSAttributedString(string: targetTitle, attributes: contentAttributes)
        case .commented:
            let note = self.note ?? ""
            return NSAttributedString(string: note.flattenHtml.trimmingCharacters(in: .newlines), attributes: contentAttributes)
        case .merged:
            return NSAttributedString(string: eventContent, attributes: contentAttributes)
        default:
            return NSAttributedString()
        }
    }
}
