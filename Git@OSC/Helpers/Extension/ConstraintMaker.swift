//
//  ConstraintMaker.swift
//  Git@OSC
//
//  Created by strayRed on 2019/6/2.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation

import SnapKit

extension ConstraintMaker {
    func edgesEqualTo(view: UIView?, with controller: UIViewController?) {
        guard let view = view, let controller = controller else { return }
        if #available(iOS 11, *) {
            self.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        else {
            self.trailing.leading.equalTo(view)
            self.top.equalTo(controller.topLayoutGuide.snp.bottom)
            self.bottom.equalTo(controller.bottomLayoutGuide.snp.top)
        }
        
    }
}
