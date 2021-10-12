//
//  HCDropdownView.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/23.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

extension HCDropdownView {
    var dropTitles: [String] {
        guard let titles = self.titles as? [String] else { return [] }
        return titles
    }
}
