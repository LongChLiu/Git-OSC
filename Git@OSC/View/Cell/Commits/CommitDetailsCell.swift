//
//  CommitDetailsCell.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/24.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class CommitDetailsCell: UITableViewCell, RenderableCell {
    @IBOutlet weak var diffLabel: UILabel!
    @IBOutlet weak var pathLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        diffLabel.font = UIFont.middle.normal
        diffLabel.textColor = .normalText
        pathLabel.font = UIFont.small.normal
        pathLabel.textColor = .lightGray
        // Initialization code
    }
    
    func render(strings: String?...) {
        diffLabel.text = strings[0]
        pathLabel.text = strings[1]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
