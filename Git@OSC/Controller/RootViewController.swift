//
//  RootViewController.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/9.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class RootViewController: UITabBarController, Bindable  {
    
    var disposeBag: DisposeBag = .init()
    
    
    init(childControllers: [UIViewController], titles: [String], normalImgs:[UIImage?], selectedImgs: [UIImage?]) {
        super.init(nibName: nil, bundle: nil)
        var i = 0
        for _ in childControllers {
            add(childController: childControllers[i], normalImage: normalImgs[i] ?? UIImage(), selectedImage: selectedImgs[i] ?? UIImage(), title: titles[i])
            i += 1
        }
        tabBar.isTranslucent = false
        
        NightModeViewModel.shared.normalBackgroud.bind(to: self.tabBar.rx.barTintColor).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func add(childController: UIViewController, normalImage: UIImage, selectedImage: UIImage, title: String) {
        self.addChild(childController)
        childController.tabBarItem.image = normalImage.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.title = title
//        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.small.normal, NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
//
//        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.small.normal, NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
