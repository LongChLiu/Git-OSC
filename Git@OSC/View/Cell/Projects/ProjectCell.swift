//
//  ProjectCell.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/15.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProjectCell: TableViewCell, PortraitTappable  {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var portraitInfo: PortraitInfo = (nil, nil)
    
    var reuseableBag: DisposeBag = DisposeBag()
    
    private var tap: ((Int64) -> ())?
    
    @IBOutlet weak var portraitButton: UIButton!
    @IBOutlet weak var namespaceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var recomImageView: UIImageView!
    
    @IBOutlet var countLabels: [UILabel]!
    
    @IBOutlet weak var namespaceLabelLeading: NSLayoutConstraint!
    
    override func prepareForReuse() {
        reuseableBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        namespaceLabel.font = UIFont.middle.blod
        descriptionLabel.font = UIFont.middle.normal
        setupNmBindingWith(cells: self)
        setupNmBindingWith(normalLabels: descriptionLabel)
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}


extension ProjectCell {
    //----------render-------//
    func render(strings: String?...) {
        namespaceLabel.text = strings[0]
        descriptionLabel.text = strings[1]
        languageLabel.text = strings[2]
        //portraitInfo
        portraitInfo.1 = String(strings[0]?.split(whereSeparator: { $0 == "/" })[0] ?? "")
        
    }
    
    func render(bools: Bool?...) {
        if bools[0] ?? false == false {
            recomImageView.isHidden = true
            namespaceLabelLeading.constant = 8
        }
        else {
            recomImageView.isHidden = false
            namespaceLabelLeading.constant = 31
        }
    }
    
    func render(imageURL: String?) {
        portraitButton.sd_setBackgroundImage(with: URL(string: imageURL ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "tx"))
    }
    
    func render(nums: Int32?...) {
        var i = 0
        for _ in countLabels {
            countLabels[i].text = String(describing: nums[i] ?? 0)
            i += 1
        }
    }
    
    func render(nums: Int64?...) {
        portraitInfo.0 = nums[0]
    }
}
