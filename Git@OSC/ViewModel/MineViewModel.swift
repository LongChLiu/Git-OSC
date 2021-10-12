//
//  MineViewModel.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/20.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MineViewModel {
    
    let initItem: BehaviorRelay<User>
    
    lazy var content: Driver<[Section]> = {
        return self.initItem.asDriver().map({ [weak self] (user) -> [Section] in
            guard let self = self else { return [] }
            return self.getSectionsWith(user: user)
        })
    }()
    
    init() {
        initItem = BehaviorRelay.init(value: CurrentUserManger.currentUser)
    }
    
    private func getSectionsWith(user: User) -> [Section] {
        let following = "Following:" + String(user.following.value ?? 0)
        let followers = "Follower:" + String(user.followers.value ?? 0)
        let starred = "Starred:" + String(user.started.value ?? 0)
        let watched = "Watched:" + String(user.watched.value ?? 0)
        var sectionAItems = [following, followers, starred, watched].map { NormalObject(text: $0) }
        sectionAItems.insert(NormalObject(text: user.userName, imageURL: user.portrait), at: 0)
        let sectionA = Section(items: sectionAItems)
        
        let createdDate = "\(String.Local.joinDate):" + (user.createdAt?.toString(.date(.medium)) ?? "unknown")
        let weibo = "\(String.Local.weibo):" + (user.weibo ?? "")
        let blog = "\(String.Local.blog):" + (user.blog ?? "")
        let sectionB = Section(items: [createdDate, weibo, blog].map { NormalObject(text: $0) })
        return [sectionA, sectionB]
    }
}
