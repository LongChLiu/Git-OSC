//
//  PageViewPresentable.swift
//  Git@OSC
//
//  Created by strayRed on 2019/6/3.
//  Copyright © 2019 Red. All rights reserved.
//

import Foundation

protocol PageViewPresentable {
    var titles: [String] { get }
    var pageViewManager: DNSPageViewManager { get }
}

extension PageViewPresentable where Self: Bindable & UIViewController {
    func setupNavigationTitleStyle() {
        let titleView = pageViewManager.titleView
        titleView.frame = CGRect.init(x: 0, y: 0, width: .screenWidth, height: 44)
        view.addSubview(titleView)
        view.addSubview(pageViewManager.contentView)
        
        navigationItem.titleView = titleView
        
        pageViewManager.contentView.snp.makeConstraints {[weak self] (maker) in
            maker.edgesEqualTo(view: self?.view, with: self)
        }
    }
    
    func setupCustomStyle() {
        let titleView = pageViewManager.titleView
        titleView.frame = CGRect.init(x: 0, y: 0, width: .screenWidth, height: 44)
        view.addSubview(titleView)
        view.addSubview(pageViewManager.contentView)
        
        NightModeViewModel.shared.pageViewStyle.bind(to: pageViewManager.rx.titleStyle).disposed(by: disposeBag)
        
        pageViewManager.contentView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(40)
            if #available(iOS 11, *) {
                maker.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                maker.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            else {
                maker.leading.trailing.equalToSuperview()
                maker.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
}
