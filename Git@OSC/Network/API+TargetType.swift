//
//  API+TargetType.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/11.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import Alamofire


private struct API {
    static let base         = URL(string: "https://git.oschina.net/api/v3/")!
    static let host         = URL(string: "https://git.oschina.net/")!
    static let projects     = "projects"
    
    static let featured     = "projects/featured"
    static let popular      = "projects/popular"
    static let latest       = "projects/latest"
    

    static let userProjects   = "user/%lld/projects"
    static let staredProjects = "user/%lld/stared_projects"
    static let watchedProjects = "user/%lld/watched_projects"

    static let userEvents = "events/user/%lld"
    static let selfEvents = "events"
    static let files = "projects/%@/repository/tree"
    static let languageList   = "projects/languages"
    static let languagedProjects = "projects/languages/%ld"
    static let projectCommits = "projects/%lld/repository/commits"
    static let projectBanrches = "projects/%lld/repository/branches"
    static let projectsSearch = "projects/search/%@"
    static let commitsDetails = "projects/%lld/repository/commits/%@/diff"
    static let projectDetails = "projects/%lld"
    static let projectIssues = "projects/%lld/issues"
    static let readme = "projects/%lld/readme"
    static let otherFiles = "projects/%@/repository/files"
    static let login = "session"
    
    static let imageFile = "%@/raw/master/%@"
    static let commitChanged = "projects/%lld/repository/commits/%@/blob"
    static let issueNotes = "projects/%lld/issues/%lld/notes"
    static let starProject = "projects/%@/star"
    static let unstarProject = "projects/%@/unstar"
    static let watchProject = "projects/%@/watch"
    static let unwatchProject = "projects/%@/unwatch"
    static let createIssue = "projects/%lld/issues"
    
    static let privateToken = "private_token"
    static let repository   = "repository"
    static let commits      = "commits"
    static let tree         = "tree"
    static let events       = "events"
    static let user         = "user"
    static let stared_projects = "stared_projects"
    static let watched_projects = "watched_projects"
    static let refName = "ref_name"
    static let page = "page"
    
    
}

protocol TargetType {
    //net
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    
    //title for the controller
    var title: String? { get }
    var noDataDescription: String { get }
}

extension TargetType {
    var url: URL {
        let string = baseURL.absoluteString + path

        guard let url = URL(string: baseURL.absoluteString + path) else {
            return URL.init(string: string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        }
        return url
    }
    var title: String? { return nil }
    
    var noDataDescription: String { return String.Local.noData }
}


//MARK: - extension: ItemsType
extension ItemsType: TargetType {
    var baseURL: URL {
        return API.base
    }
    var path: String {
        switch self {
        case .featuredProjs: return API.featured
        case .popularProjs: return API.popular
        case .latestProjs: return API.latest
        case .userProjs(let id):
            return String(format: API.userProjects, id)
        case .staredProjs(let id):
            return String(format: API.staredProjects, id)
        case .watchedProjs(let id):
            return String(format: API.watchedProjects, id)
        case .languagedProjs(let id, _):
            return String(format: API.languagedProjects, id)
        case .userEvents(let id):
            return String(format: API.userEvents, id)
        case .selfEvents:
            return API.selfEvents
        case .files(let info):
             guard let projectId = info[File.projectId] else { fatalError("Unexpected Error") }
            return String(format: API.files, projectId)
        case .projectCommits(let proId):
            return String(format: API.projectCommits, proId)
        case .projectBanrches(let proId):
            return String(format: API.projectBanrches, proId)
        case .commitsDetails(let proId, let comId):
            return String(format: API.commitsDetails, proId, comId)
        case .projectIssues(let proId):
            return String(format: API.projectIssues, proId)
        case .issueNotes(let proId, let issueId):
            return String(format: API.issueNotes, proId, issueId)
        case .languageList:
            return API.languageList
        case .projectsSearch(let query):
            return String(format: API.projectsSearch, query)
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .featuredProjs, .latestProjs, .popularProjs, .userEvents(_), .staredProjs(_), .watchedProjs(_), .userProjs(_), .languagedProjs(_):
            return [API.page: 1]
        case .files(let fileInfo):
            return [API.privateToken: CurrentUserManger.privateToken, API.refName: "master", "path": fileInfo[File.currentPath] ?? ""]
        case .projectIssues(_), .issueNotes(_, _), .selfEvents, .projectsSearch(_):
            return [API.page: 1, API.privateToken: CurrentUserManger.privateToken]
        case .commitsDetails(_, _):
            return [API.privateToken: CurrentUserManger.privateToken]
        default: return nil
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var title: String? {
        switch self {
        case .languagedProjs(_, let language):
            return language
        case .files(let info):
            return info[File.fileName]
        case .projectIssues(_):
            return String.Local.issue
        case .issueNotes(_, _):
            return String.Local.issueDetails
        case .languageList:
            return String.Local.discover
        default: return nil
        }
    }
    
    var noDataDescription: String {
        switch self {
        case .projectsSearch(_):
            return "暂无相关搜索结果"
        case .userProjs(_):
            return "暂无相关项目"
        case .selfEvents, .userEvents(_):
            return "暂无相关动态"
        case .projectIssues(_):
            return "暂无Issue"
        default: return String.Local.noData
        }
    }
}
//MARK: - extension: ItemType
extension ItemType: TargetType {
    var baseURL: URL {
        return API.base
    }
    
    var path: String {
        switch self {
        case .projsDetails(let id):
            return String.init(format: API.projectDetails, id)
        case .user(_), .currentUser: return ""
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .projsDetails(_):
            return [API.privateToken: CurrentUserManger.privateToken]
        case .user(_), .currentUser: return nil
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    
}

//MARK: - extension: BlobFileType
extension BlobFileType: TargetType {
    var method: HTTPMethod {
        return .get
    }

    var baseURL: URL {
        switch self {
        case .image(_): return API.host
        default: return API.base
        }
    }
    var path: String {
        switch self {
        case .readme(let projectId):
            return String(format: API.readme, projectId)
        case .code(let info):
            return String(format: API.otherFiles, info[File.projectId] ?? "")
        case .image(let info):
            return String(format: API.imageFile, info[File.namespace] ?? "", info[File.currentPath] ?? "")
        case .commitChanged(let commit, _):
            return String(format: API.commitChanged, commit.projectId.value ?? "", commit.id)
        }
    }
    var parameters: [String : Any]? {
        switch self {
        case .readme(_):
            return [API.privateToken: CurrentUserManger.privateToken]
        case .code(let info):
            return [API.privateToken: CurrentUserManger.privateToken, "ref": "master", "file_path": String(info[File.currentPath]!.dropLast())]
        case .commitChanged(_, let path):
            return [API.privateToken: CurrentUserManger.privateToken, "filepath": path]
        case .image(_):
            return [API.privateToken: CurrentUserManger.privateToken]
        }
    }
    
    var title: String? {
        switch self {
        case .readme(_):
            return "Readme"
        case .code(let info), .image(let info):
            return info[File.fileName]
        case .commitChanged(_, let path):
            return path.pathFileName
        }
    }
    
    var noDataDescription: String {
        switch self {
        case .image(_): return String.Local.imageError
        default: return String.Local.fileError
        }
    }
}


//MARK: - extension: ActionApi
extension ActionAPI: TargetType {
    var baseURL: URL {
        return API.base
    }
    
    var path: String {
        switch self {
        case .starProject(let nameSpace):
            return String(format: API.starProject, nameSpace)
        case .watchProject(let nameSpace):
            return String(format: API.watchProject, nameSpace)
        case .unstarProject(let nameSpace):
            return String(format: API.unstarProject, nameSpace)
        case .unwatchProject(let nameSpace):
            return String(format: API.unwatchProject, nameSpace)
        case .createIssue(let projectID, _ , _):
            return String(format: API.createIssue, projectID)
        case .login(_, _):
            return API.login
        case .none: return ""
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .createIssue(_, _, _):
            var para = Issue.creationParam(via: self)
            para[API.privateToken] = CurrentUserManger.privateToken
            return para
        case .login(let email, let password):
            return ["email": email ?? "", "password": password ?? ""]
        case .none: return nil
        default: return [API.privateToken: CurrentUserManger.privateToken]
        
        }
        
    }
    
}
