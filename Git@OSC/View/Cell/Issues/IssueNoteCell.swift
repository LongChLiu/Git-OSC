//
//  IssueNoteCell.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/25.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class IssueNoteCell: TableViewCell, PortraitTappable {
    
    var disposeBag: DisposeBag = .init()
    
    var reuseableBag: DisposeBag = .init()
    
    var portraitInfo: PortraitInfo = (nil, nil)
    

    @IBOutlet weak var portraitButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func prepareForReuse() {
        disposeBag = .init()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont.middle.normal
        nameLabel.textColor = .theme
        contentLabel.font = UIFont.middle.normal
        timeLabel.font = UIFont.small.normal
        timeLabel.textColor = .lightGray
        setupNmBindingWith(cells: self)
        setupNmBindingWith(normalLabels: nameLabel, contentLabel)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(imageURL: String?) {
        portraitButton.sd_setBackgroundImage(with: URL(string: imageURL ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "tx"))
    }
    
    func render(strings: String?...) {
        nameLabel.text = strings[0]
        contentLabel.text = strings[1]
        timeLabel.text = strings[2]
        portraitInfo.1 = strings[0]
    }
    
    func render(nums: Int64?...) {
        portraitInfo.0 = nums[0]
    }
    
}
