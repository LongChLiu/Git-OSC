//
//  MineInfoCell.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/20.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

final class MineInfoCell: TableViewCell {
    var disposeBag: DisposeBag = .init()
    private let label: UILabel = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupNmBindingWith(cells: self)
        contentView.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().offset(-16)
        }
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.middle.normal
        label.textColor = .gray
    }
    

    func render(string: String?) {
        label.text = string
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
