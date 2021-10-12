//
//  ReadmeController.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/5.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class HtmlViewController: UIViewController, NetAccessableControllerType,  IndicatorPresentable, ErrorViewPresentable {
    
    let disposeBag: DisposeBag = DisposeBag()
    
    let viewModel: HtmlViewModel
    
    private let webView = WKWebView()
    
    weak var delegate: PushableControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        // Do any additional setup after loading the view.
    }
    
    private func setupSubViews() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        setupIndicatorWith(backgroundStyle: .normal, showNow: true)
        setupErrorView()
        request()
        
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.showsHorizontalScrollIndicator = true
        viewModel.navigationTitle.drive(navigationItem.rx.title).disposed(by: disposeBag)
        webView.rx.navigationDidFinish.bind(to: indicator.rx.hide).disposed(by: disposeBag)
    }
    
    func request() {
        //show indicatorView
        viewModel.request.subscribe(onNext: {[weak self] (htmlString) in
            self?.webView.loadHTMLString(htmlString, baseURL: URL(fileURLWithPath: Bundle.main.bundlePath))
        }).disposed(by: disposeBag)
        viewModel.errorViewConfig.drive(self.errorView.rx.config).disposed(by: disposeBag)
    }
    
    init(viewModel: HtmlViewModel) {
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
