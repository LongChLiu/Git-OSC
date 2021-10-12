//
//  String.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/9.
//  Copyright © 2018 Git@OSC. All rights reserved.
//
import UIKit
import Foundation

extension String {
    
    struct Local {
        static let projects    = "Projects".localized
        static let discover    = "Discover".localized
        static let mine        = "Mine".localized
        static let featured    = "Featured".localized
        static let popular     = "Popular".localized
        static let latest      = "Latest".localized
        static let unkownError = "UnknownError".localized
        static let noMoreData  = "NoMoreData".localized
        static let noData      = "NoData".localized
        static let noPermission = "NoPermission".localized
        static let defaultDescription = "DefaultProjDescription".localized
        static let defaultLanguage    = "DefaultLanguage".localized
        static let defaultReadme      = "DefaultReadme".localized
        static let unknownFileType    = "UnknownFileType".localized
        static let imageError         = "ImageError".localized
        static let fileError          = "FileError".localized
        static let unsupportedFileType = "UnsupportedFileType".localized
        static let owner  = "Owner".localized
        static let readme = "Readme".localized
        static let code   = "Code".localized
        static let issue  = "Issue".localized
        static let issueDetails = "IssueDetails".localized
        static let branch = "Branch".localized
        static let events = "Events".localized
        static let login  = "Login".localized
        
        static let loginError = "LoginError".localized
        static let requestError = "RequestError".localized
        static let parseFailed = "ParseFailed".localized
        
        static let joinDate = "JionDate".localized
        static let weibo    = "Weibo".localized
        static let blog     = "Blog".localized
        static let logout   = "Logout".localized
        
        static let projectsSearch = "ProjectsSearch".localized
        
    }

    private var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var pathFileName: String {
        if self.contains("/") {
            return String(self.split(separator: "/").last ?? "")
        }
        return self
    }
    
    var FileExtensionName: String {
        if self.contains(".") {
            return String(self.split(separator: ".").last ?? "")
        }
        return ""
    }

    var isCodeFileName: Bool {
        if self == "" { return false }
        for suffix in StaticData.File.codeSuffixes {
            if self.hasSuffix(suffix) { return true }
        }
        for fileName in StaticData.File.specialName {
            if self.hasPrefix(fileName) { return true }
        }
        return false

    }
    
    var isImageFileName: Bool {
        if self == "" { return false }
        for suffix in StaticData.File.imageSuffixes {
            if self.hasSuffix(suffix) {
                return true
            }
        }
        return false
    }
    
    
    func height(with font: UIFont, maxWidth: CGFloat) -> CGFloat {
        let att = [NSAttributedString.Key.font: font]
        let maxSize = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
        return (self as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: att, context: nil).size.height
    }
    
    static var preferredLanguage: String {
        let userDefaults = UserDefaults.standard
        return userDefaults.array(forKey: "AppleLanguages")?[0] as! String
    }
    
    
    var flattenHtml: String {
        var selfCopy = self
        let scanner = Scanner.init(string: selfCopy)
        var mark: NSString? = nil
        while !scanner.isAtEnd {
            //移动Location到<之前
            scanner.scanUpTo("<", into: nil)
            //获取标签（>之前）
            scanner.scanUpTo(">", into: &mark)
            //删除标签
            selfCopy = selfCopy.replacingOccurrences(of: String(format: "%@>", mark ?? ""), with: "")
        }
        return selfCopy
    }
}



