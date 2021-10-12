//
//  ImageViewController.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/19.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ImageViewController: UIViewController, NetAccessableControllerType, IndicatorPresentable, ErrorViewPresentable {
    
    let disposeBag: DisposeBag = .init()
    
    let imageView: UIImageView = .init()

    let viewModel: ImageViewModel
    
    weak var delegate: PushableControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupIndicatorWith(backgroundStyle: .clear, showNow: true)
        setupErrorView()
        
        viewModel.navigationTitle.drive(navigationItem.rx.title).disposed(by: disposeBag)
    
        request()
        
        // Do any additional setup after loading the view.
    }
    
    

    func request() {
        viewModel.request.subscribe(onNext: { [weak self] image in
            let browser = ImageBrowser(image: image, frame: self?.view.bounds ?? CGRect.zero)
            self?.view.addSubview(browser)
            
        }).disposed(by: disposeBag)
        bindRequestViews()
    }
    
    init(viewModel: ImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
