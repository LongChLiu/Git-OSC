//
//  CommitDetailsViewModel.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/24.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire

class CommitDetailsViewModel: ItemsViewModelType {
    
    lazy var loadMore: Observable<()> = { return self.requestObservable() }()
    
    typealias S = CommitDetailsStore
    
    lazy var request: Observable<()> = { return self.requestObservable() }()
    
    lazy var page: BehaviorRelay<Int> = .init(value: 2)

    lazy var dataSource: Driver<[CommitDetail]> = { return self.dataSource() }()
    
    lazy var requestObservable: Observable<()> = { return self.requestObservable() }()
    
    lazy var requestParam: [String : Any]? = { return self.defaultParam }()
    
    let initItems: BehaviorRelay<[CommitDetail]>
    
    let store: CommitDetailsStore
    
    let uuid = UUID()
    
    let commit: ProjectCommit
    
    lazy var contents: Driver<[Section]> = {
        return dataSource.map { [unowned self] in [Section(items: [self.commit as RenderableObject]), Section(items: $0)] }
    }()
    
    required init(store: CommitDetailsStore, commit: ProjectCommit) {
        self.store = store
        self.commit = commit
        self.initItems = BehaviorRelay<[CommitDetail]>(value: store.items)
    }
    
}
