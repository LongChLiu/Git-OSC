//
//  TableViewPresentable.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/21.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa


protocol TableViewPresentable: NightModeChangable, UITableViewDelegate {
    var tableView: UITableView { get }
    var cellInfo: [(String, RegisteredViewType)] { get }
    /// 需要在调用协议代理之前初始化
    var tableViewDelegate: RxTableViewSectionedReloadDelegate { get }
    func cellReuseIdentifier(for indexPath: IndexPath) -> String
    func setupCell(_ cell: UITableViewCell, with indexPath: IndexPath)
}

extension TableViewPresentable where Self: BaseControllerType {
    var dataSource: RxTableViewSectionedReloadDataSource<Section> {
        return RxTableViewSectionedReloadDataSource(configureCell: {[weak self] (ds, tableView, indxPath, item) -> UITableViewCell in
            guard let self = self, let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier(for: indxPath)) as? RenderableTableViewCell else { return UITableViewCell() }
            self.setupCell(cell, with: indxPath)
            item.render(cell: cell)
            if let portraitCell = cell as? PortraitTappable {
                portraitCell.tapPortrait { [weak self] id, name in self?.delegate?.pushUserControllerWith(userId: id, userName: name, navigation: self?.navigationController)
                }
            }
            return cell
        })
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        setupNmBindingWith(tableView: tableView)
        NightModeViewModel.shared.normalBackgroud.bind(to: self.view.rx.backgroundColor).disposed(by: disposeBag)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        cellInfo.forEach { (name, type) in
            switch type {
            case .class: tableView.register(NSClassFromString("Git_OSC." + name), forCellReuseIdentifier: name)
            case .xib: tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
            }
        }
    }
    
    func setupCell(_ cell: UITableViewCell, with indexPath: IndexPath) { }
}
