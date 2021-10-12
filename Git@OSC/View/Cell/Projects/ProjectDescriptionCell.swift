//
//  ProjectDescriptionCell.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/3.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProjectDescriptionCell: TableViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
     @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var watchLabel: UILabel!
    
    
    
    
    override func prepareForReuse() {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentLabel.font = UIFont.middle.normal
        starButton.titleLabel?.font = UIFont.middle.blod
        watchButton.titleLabel?.font = UIFont.middle.blod
        starLabel.font = UIFont.small.normal
        watchLabel.font = UIFont.small.normal
        
        starButton.backgroundColor = .lucidGray
        watchButton.backgroundColor = .lucidGray
        
        starLabel.layer.borderColor = UIColor.lucidGray.cgColor
        starLabel.layer.borderWidth = 0.5
        watchLabel.layer.borderColor = UIColor.lucidGray.cgColor
        watchLabel.layer.borderWidth = 0.5
        starButton.setTitle("Unstar", for: .selected)
        watchButton.setTitle("Unwatch", for: .selected)
        
        touchBindingWith(buttons: starButton, watchButton)

        selectionStyle = .none
        
        setupNmBindingWith(cells: self)
        setupNmBindingWith(normalLabels: contentLabel, starLabel, watchLabel)

        
        //kvo
//        self.rx.observe(Bool.self, "starButton.selected").skip(1).map { [weak self] (isSelected) -> String in
//            guard let self = self else { return ""}
//            if let isSelected = isSelected, isSelected {
//                self.starNum += 1
//                return String(self.starNum) + " stars"
//            }
//            else {
//                self.starNum -= 1
//                return String(self.starNum) + " stars"
//
//            }
//        }.bind(to: starLabel.rx.text).disposed(by: disposeBag)
//
//
//        self.rx.observeWeakly(Bool.self, "watchButton.selected").skip(1).map { [weak self] (isSelected) -> String in
//            guard let self = self else { return ""}
//            if let isSelected = isSelected, isSelected {
//                self.watchNum += 1
//                return String(self.watchNum) + " watchs"
//            }
//            else {
//                self.watchNum -= 1
//                return String(self.watchNum) + " watchs"
//
//            }
//        }.bind(to: watchLabel.rx.text).disposed(by: disposeBag)
//
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 防止点击选中的按钮出现高亮效果
    private func touchBindingWith(buttons: UIButton...) {
        for button in buttons {
            button.rx.controlEvent(.allTouchEvents).bind { (_) in
                if button.isSelected {
                    button.isHighlighted = false
                }
            }.disposed(by: disposeBag)
        }
    }
}

extension ProjectDescriptionCell {
    func render(strings: String?...) {
        contentLabel.text = strings[1]
    }
    
    func render(nums: Int32?...) {
        starLabel.text = String(nums[1] ?? 0) + " stars"
        watchLabel.text = String(nums[2] ?? 0) + " watchs"
    }
    
    func render(bools: Bool?...) {
        starButton.isSelected = bools[2] ?? false
        watchButton.isSelected = bools[3] ?? false
    }
}
