//
//  MinePageController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/15.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class MinePageController: UIViewController, HasDelegate, Bindable, PageViewPresentable {
    
    var disposeBag: DisposeBag = .init()
    

    weak var delegate: PushableControllerDelegate?
    
    var titles: [String]
    
    var pageViewManager: DNSPageViewManager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomStyle()
        
        //barButtonItem
        let portraitButton = UIButton(type: .custom)
        portraitButton.setPortraitImgeWith(urlString: CurrentUserManger.portraitURL)
        portraitButton.layer.masksToBounds = true
        portraitButton.layer.cornerRadius = 15
        portraitButton.adjustsImageWhenHighlighted = false
        portraitButton.frame = .init(origin: .zero, size: .init(width: 30, height: 30))
        let view = UIView.init(frame: portraitButton.bounds)
        view.addSubview(portraitButton)
        navigationItem.setLeftBarButton(.init(customView: view), animated: true)
        portraitButton.rx.tap.bind { [weak self] (_) in
            self?.delegate?.pushMineControllerWith(navigation: self?.navigationController)
        }.disposed(by: disposeBag)
        
        
        let settingButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "SetUp"), style: .done, target: nil, action: nil)
        navigationItem.setRightBarButton(settingButton, animated: true)
        
        settingButton.rx.tap.bind { [weak self] (_) in
            self?.delegate?.pushSettingControlelrWith(navigation: self?.navigationController)
            }.disposed(by: disposeBag)

    
        // Do any additional setup after loading the view.
    }
    
    init(controllers: [UIViewController], titles: [String], delegate: PushableControllerDelegate?) {
        pageViewManager = .init(style: .navigationTitle, titles: titles, childViewControllers: controllers)
        self.titles = titles
        self.delegate = delegate
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
