//
//  ItemsController.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/16.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit
import Alamofire
import MJRefresh

protocol ItemsController: NetAccessableControllerType, TableViewPresentable, HintViewsPresentable where V: ItemsViewModelType {
    
    var isRefreshable: Bool { get }
    
    var isPageable: Bool { get }
    
}

extension ItemsController {
    
    func request() {
        if isRefreshable {
            tableView.mj_header!.beginRefreshing()
            return
        }
        bindRequestViews()
    }
    
    func setupSubViews(via requestParam: [String: Any]? = nil, itemSelected: @escaping (IndexPath)->() ) {
        
        if requestParam != nil {
            viewModel.requestParam = requestParam
        }
        
        if isRefreshable { setupRefreshHeader() }
        
        //viewConfig
        setupTableView()
        setupIndicatorWith(backgroundStyle: .normal)
        setupErrorView()
        setupTextHUD()
        request()
        
        /*--------------------binding-----------------------*/
        //标题
        viewModel.navigationTitle.drive(navigationItem.rx.title).disposed(by: disposeBag)
        //载入菊花是否显示
        viewModel.isLocalDataExistd.drive(indicator.rx.isHidden).disposed(by: disposeBag)
        //数据源
        viewModel.contents.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        //cell高度
        viewModel.cellHeight.drive(tableView.rx.cellHeights(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
        //cell点击
        tableView.rx.itemSelected.bind { [weak self] (index:IndexPath) in
            guard let self = self else { return }
            self.tableView.deselectRow(at: index, animated: true)
            itemSelected(index)
        }.disposed(by: disposeBag);
        
        
        //是否添加footer
        viewModel.dataSource.filter { $0.count == 20 }.asObservable().bind { [weak self] (_) in
            guard let self = self, self.isPageable else { return }
            self.setupRefreshFooter()
        }.disposed(by: disposeBag)
    }
    
    private func setupRefreshHeader() {
        tableView.mj_header = MJRefreshNormalHeader()
        /*通过直接订阅刷新事件来保证每次网络请求都能重新订阅Observable*/
        //header
        tableView.mj_header!.rx.refreshing.bind { [weak self] in
            
            guard let s = self else { return }
            
            s.bindRequestViews()
            
            s.viewModel.request.bind(to:s.tableView.mj_header!.rx.endRefreshing).disposed(by: s.disposeBag)
            
        }.disposed(by: disposeBag)
    }
    
    private func setupRefreshFooter() {
        tableView.mj_footer = MJRefreshAutoNormalFooter()
        //footer
        tableView.mj_footer!.rx.refreshing.bind { [weak self] in
            
            guard let s = self else { return }
            
            s.viewModel.loadMore.bind(to: s.tableView.mj_footer!.rx.endRefreshing).disposed(by: s.disposeBag)
            
        }.disposed(by: disposeBag)
    }
    
}
