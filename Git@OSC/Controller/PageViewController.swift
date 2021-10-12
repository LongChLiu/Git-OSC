//
//  PageViewController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/7.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class PageViewController: UIViewController, Bindable, PageViewPresentable {
    var disposeBag: DisposeBag = .init()
    
    let titles: [String]
    
    let pageViewManager: DNSPageViewManager

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitleStyle()
    
        // Do any additional setup after loading the view.
    }
    
    init(controllers: [UIViewController], titles: [String]) {
        pageViewManager = .init(style: .navigationTitle, titles: titles, childViewControllers: controllers)
        self.titles = titles
        super.init(nibName: nil, bundle: nil)
        for vc in controllers {
            self.addChild(vc)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
