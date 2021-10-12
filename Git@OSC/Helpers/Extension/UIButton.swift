//
//  UIButton.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/20.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

extension UIButton {
    func setPortraitImgeWith(urlString: String?) {
        self.sd_setBackgroundImage(with: URL(string: urlString ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "tx"))
    }
}
