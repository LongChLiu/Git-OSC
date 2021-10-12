//
//  CommitsCell.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/22.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class CommitsCell: TableViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var portraitImgeView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = UIFont.middle.blod
        contentLabel.font = UIFont.middle.normal
        timeLabel.font = UIFont.small.normal
        timeLabel.textColor = UIColor.lightGray
        setupNmBindingWith(cells: self)
        setupNmBindingWith(normalLabels: contentLabel)
    }
    
    func render(imageURL: String?) {
        portraitImgeView.sd_setImage(with: URL(string: imageURL ?? ""), placeholderImage: #imageLiteral(resourceName: "tx"))
    }
    
    func render(strings: String?...) {
        titleLabel.text = strings[0]
        contentLabel.text = strings[1]
        timeLabel.text = strings[2]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
