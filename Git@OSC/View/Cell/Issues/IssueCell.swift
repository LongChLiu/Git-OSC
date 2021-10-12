//
//  IssueCell.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/23.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class IssueCell: TableViewCell, PortraitTappable {
    
    var reuseableBag: DisposeBag = DisposeBag()
    
    var portraitInfo: PortraitInfo = (nil, nil)
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var portraitButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func prepareForReuse() {
        reuseableBag = DisposeBag()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.middle.normal
        infoLabel.font = UIFont.small.normal
        infoLabel.textColor = UIColor.lightGray
        setupNmBindingWith(cells: self)
        setupNmBindingWith(normalLabels: titleLabel)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension IssueCell {
    func render(imageURL: String?) {
        portraitButton.sd_setBackgroundImage(with: URL(string: imageURL ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "tx"))
    }
    
    func render(strings: String?...) {
        titleLabel.text = strings[0]
        infoLabel.text = strings[1]
        portraitInfo.1 = strings[2]
    }
    func render(nums: Int64?...) {
        portraitInfo.0 = nums[0]
    }
}
