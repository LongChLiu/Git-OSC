//
//  ProjectListViewModel.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/12.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources


final class ItemsViewModel<S: ItemsStoreType>: ItemsViewModelType {
    
    let initItems: BehaviorRelay<[S.O]>
    
    let uuid = UUID()
    
    lazy var requestParam: [String : Any]? = { return self.defaultParam }()
    
    let store: S
    
    lazy var page = BehaviorRelay(value: 2)
    
    let data = BehaviorSubject<[[Item]]>.init(value: [])
    
    /*---------observable---------------------*/

   //使用存储属性保证序列的唯一性
    lazy var request: Observable<()> = {return self.requestObservable() }()
    
    lazy var loadMore: Observable<()> = { return self.loadMoreObservable() }()
    
    lazy var dataSource: Driver<[S.O]> = { return self.dataSource() }()
    
    
    var contents: Driver<[Section]> {
        return dataSource.map { [Section(items: $0)] }
    }
    
    //MARK:- 初始化
    init(store: S) {
        self.store = store
        //初始化BehaviorRelay 启动观察者序列
        self.initItems = BehaviorRelay(value: store.items)
    }
    
}



