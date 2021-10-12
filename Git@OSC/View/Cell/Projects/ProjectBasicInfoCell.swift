//
//  ProjectBasicInfoCell.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/3.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class ProjectBasicInfoCell: TableViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var publicLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
        setupNmBindingWith(cells: self)

        
        // Initialization code
    }
    
    func render(strings: String?...) {
        timeLabel.text = strings[3]
        languageLabel.text = strings[2]
    }
    func render(nums: Int32?...) {
        forkLabel.text = String(nums[0] ?? 0)
    }
    func render(bools: Bool?...) {
        publicLabel.text =  bools[1] ?? false ? "Public" : "Private"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


