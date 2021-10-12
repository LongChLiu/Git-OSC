//
//  ProjectNameCell.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/3.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProjectNameCell: TableViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        isUserInteractionEnabled = false
        super.awakeFromNib()
        
        setupNmBindingWith(cells: self)
        setupNmBindingWith(normalLabels: projectNameLabel, timeLabel, updatedLabel)
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(string: String?) {
        projectNameLabel.text = string
    }
    
    
    func render(strings: String?...) {
        //time
        timeLabel.text = strings[3]
    }
    
    func render(imageURL: String?) {
        portraitImageView.sd_setImage(with: URL(string: imageURL ?? ""), completed: nil)
    }
}

extension ProjectNameCell {
    
}
