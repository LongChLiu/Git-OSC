//
//  errorView.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/29.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: ErrorView {
    
    var config: Binder<(Bool, (String?, UIImage?))> {
        return Binder<(Bool, (String?, UIImage?))>(base, binding: { (base, tup) in
            base.isHidden = tup.0
            base.configLayout(with: tup.1.0, image: tup.1.1)
        })
    }
    
    var refreshing: ControlEvent<()> {
        return  base.refreshButton.rx.tap
    }
    
}


class ErrorView: UIView {
    
    let refreshButton = UIButton()
    private let label = UILabel()
    private let imageView = UIImageView()
    private let disposeBag = DisposeBag()
    
    
    init() {
        super.init(frame: CGRect.zero)
        setupSubViews()
    }
    
    
    func configLayout(with text: String?, image: UIImage?) {
        //设置layout
        label.text = text
        if let image = image {
            imageView.image = image
            imageView.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
                maker.size.equalTo(image.size)
            }
            label.snp.makeConstraints { (maker) in
                maker.width.equalToSuperview()
                maker.top.equalTo(imageView.snp.bottom).offset(8)
            }
        }
        else {
            label.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
            }
        }

    }
    
    private func setupSubViews() {
        self.backgroundColor = .white
        self.addSubview(imageView)
        self.addSubview(label)
        label.font = UIFont.middle.normal
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        self.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    deinit {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
