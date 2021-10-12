//
//  NightModeChangable.swift
//  Git@OSC
//
//  Created by strayRed on 2019/6/2.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

protocol NightModeChangable {}

extension NightModeChangable where Self: Bindable {
    
    func setupNmBindingWith(tableView: UITableView) {
        NightModeViewModel.shared.deepBackgroud.bind(to: tableView.rx.backgroundColor).disposed(by: disposeBag)
        NightModeViewModel.shared.deepBackgroud.bind(to: tableView.rx.separatorColor).disposed(by: disposeBag)
    }
    
    func setupNmBindingWith(cells: UITableViewCell...) {
        for cell in cells {
            //background
            NightModeViewModel.shared.normalBackgroud.bind(to: cell.rx.backgroundColor).disposed(by: disposeBag)
            //selectedColor
            if cell.isUserInteractionEnabled && cell.selectionStyle != .none {
                cell.selectedBackgroundView = UIView()
                NightModeViewModel.shared.selectedColor.bind(to: cell.selectedBackgroundView!.rx.backgroundColor).disposed(by: disposeBag)
            }
        }
    }
    
    func setupNmBindingWith(normalLabels: UILabel...) {
        normalLabels.forEach { label in
            NightModeViewModel.shared.normalTextColor.bind(to: label.rx.textColor).disposed(by: disposeBag)
        }
    }
}

