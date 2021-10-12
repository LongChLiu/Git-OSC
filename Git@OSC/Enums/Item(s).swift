//
//  KeyValue.swift
//  Git@OSC
//
//  Created by strayRed on 2019/1/11.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

enum ItemsType {
    case featuredProjs
    case popularProjs
    case latestProjs
    case userProjs(id: Int64)
    case languagedProjs(id: Int32, language: String)
    case userEvents(id: Int64)
    case selfEvents
    case files(info: [String: String])
    case staredProjs(id: Int64)
    case watchedProjs(id: Int64)
    case projectCommits(id: Int64)
    case projectBanrches(id: Int64)
    case projectIssues(id: Int64)
    case projectsSearch(query: String)
    case commitsDetails(proId: Int64, comId: String)
    case issueNotes(proId: Int64, issueId: Int64)
    case languageList
}

enum ItemType {
    case currentUser
    case projsDetails(Int64)
    case user(Int64)
}

enum BlobFileType {
    case readme(id: Int64)
    case code (info: [String: String])
    case image(info: [String: String])
    case commitChanged(commit: ProjectCommit, path: String)
}




enum ResponseKey {
    case changeReason
    case tragetType
    case identity
}

enum ChangeReason {
    case request
    case loadMore
}
