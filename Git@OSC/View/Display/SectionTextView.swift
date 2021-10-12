//
//  SectionTextView.swift
//  Git@OSC
//
//  Created by strayRed on 2019/3/1.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit

class SectionTextView: UIView {
    
    let textLabel = UILabel()
    
    init(text: String?, height: CGFloat = .sectionHeight, textAttributes: TextAttributes = TextAttributes().font(UIFont.middle.blod).foregroundColor(.normalText)) {
        super.init(frame: CGRect.init(origin: .zero, size: .init(width: .screenWidth, height: height)))
        textLabel.attributedText = NSAttributedString(string: text ?? "", attributes: textAttributes)
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(8)
            maker.right.equalToSuperview().offset(-8)
            maker.centerY.equalToSuperview()
        }
        backgroundColor = .deepBackgroud
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
