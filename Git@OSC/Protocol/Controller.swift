//
//  Controller.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/4.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseControllerType: HasDelegate where Delegate == PushableControllerDelegate {
    
    var disposeBag: DisposeBag { get }
}




protocol TableViewPresentable: UITableViewDelegate {
    var tableView: UITableView { get }
}

extension TableViewPresentable where Self: UIViewController {
    
    func setupTableView(with cellInfo: (String, RegisteredViewType)...) {
        tableView.delegate = self
        view.addSubview(tableView)
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
}
