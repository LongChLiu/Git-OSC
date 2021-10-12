//
//  MinePortraitCell.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/20.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class MinePortraitCell: TableViewCell {
    
    var disposeBag: DisposeBag = .init()
    
    @IBOutlet weak var portraitButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupNmBindingWith(cells: self)
        setupNmBindingWith(normalLabels: nameLabel)
        nameLabel.font = UIFont.middle.normal
        
        
        portraitButton.layer.masksToBounds = true
        portraitButton.layer.cornerRadius = 20
        portraitButton.adjustsImageWhenHighlighted = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(imageURL: String?) {
        portraitButton.setPortraitImgeWith(urlString: imageURL)
    }
    
    func render(string: String?) {
        nameLabel.text = string
    }
    
}
