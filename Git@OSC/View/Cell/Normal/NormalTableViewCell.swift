//
//  NormalTableViewCell.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/4.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NormalTableViewCell: TableViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(string: String?) {
        self.textLabel?.text = string
    }
    
    func render(image: UIImage?) {
        self.imageView?.image = image
    }
    
    func render(attributedString: NSAttributedString?) {
        self.textLabel?.attributedText = attributedString
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupNmBindingWith(cells: self)
        textLabel?.font = UIFont.middle.normal
        if let label = textLabel {
            setupNmBindingWith(normalLabels: label)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


