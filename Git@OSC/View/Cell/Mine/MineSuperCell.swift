//
//  MinePortraitCell.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/20.
//  Copyright © 2019 Red. All rights reserved.
//

import UIKit
import RxSwift

class MineInfoCell: TableViewCell {
    var disposeBag: DisposeBag = .init()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
