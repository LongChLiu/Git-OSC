//
//  EventsCell.swift
//  Git@OSC
//
//  Created by strayRed on 2019/1/11.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class EventsCell: TableViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var portraitButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var contentBackground: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupNmBindingWith(cells: self)
        timeLabel.font = UIFont.small.normal
        timeLabel.textColor = .lightGray
        NightModeViewModel.shared.deepBackgroud.bind(to: contentBackground.rx.backgroundColor).disposed(by: disposeBag)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension EventsCell {
    
    func render(attributedStrings: NSAttributedString?...) {
        titleLabel.attributedText = attributedStrings[0]
        contentLabel.attributedText = attributedStrings[1] ?? NSAttributedString()
        //没有内容就隐藏背景
        let isHidden = attributedStrings[1] == nil || attributedStrings[1]?.string == ""
        contentBackground.isHidden = isHidden
    }
    
    func render(imageURL: String?) {
        portraitButton.sd_setBackgroundImage(with: URL.init(string: imageURL ?? ""), for: .normal, completed: nil)
    }
    func render(string: String?) {
        timeLabel.text = string
    }
    
    func render(bool: Bool?) {
        contentBackground.isHidden = !(bool ?? false)
    }
}
