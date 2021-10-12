//
//  themeButton.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/9.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit

class ThemeButton: UIButton {
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .icon
        self.titleLabel?.font = UIFont.middle.blod
        self.adjustsImageWhenDisabled = true
        setTitleColor(.white, for: .normal)
        setTitleColor(.lightGray, for: .disabled)
    }
    

    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
