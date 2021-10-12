//
//  IssueNotesViewModel.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/25.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class IssueNotesViewModel: ItemsViewModelType {
    
    typealias S = IssueNotesStore
    
    lazy var dataSource: Driver<[IssueNote]> = { return self.dataSource() }()
    
    var store: IssueNotesStore
    
    var uuid: UUID = .init()
    
    lazy var requestParam: [String : Any]? = { return self.defaultParam }()
    
    var initItems: BehaviorRelay<[IssueNote]>
    
    var page: BehaviorRelay<Int> = .init(value: 2)
    
    lazy var request: Observable<()> = { return self.requestObservable() }()
    
    lazy var loadMore: Observable<()> = { return self.loadMoreObservable() }()
    
    var contents: Driver<[Section]>  {
        return dataSource.map { [Section(items: [self.issue]), Section(items: $0)] }
    }
    
    var isLocalDataExistd: Driver<Bool> { return Driver.just(true) }

    var textHUDConfig: Driver<(Bool, String?)> {
        return request.asTextHUDConfig(hideIn: [.parseFailed(nil), .noData(nil)])
    }
        
    let issue: IssueCopy
    
    init(store: IssueNotesStore, issue: Issue) {
        self.store = store
        self.issue = IssueCopy(issue: issue)
        self.initItems = BehaviorRelay(value: self.store.items)
        
    }

}
