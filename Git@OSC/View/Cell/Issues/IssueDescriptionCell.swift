//
//  IssueDescriptionCell.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/25.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class IssueDescriptionCell: TableViewCell, PortraitTappable, UIScrollViewDelegate, WKNavigationDelegate {
    
    var reuseableBag: DisposeBag = .init()
    
    var portraitInfo: PortraitInfo = (nil, nil)
    
     let disposeBag: DisposeBag = .init()
    
    let portraitButton: UIButton! = {
       let portraitButton = UIButton()
        portraitButton.layer.masksToBounds = true
        portraitButton.layer.cornerRadius = 10
        return portraitButton
    }()
    
    private lazy var wkWebView: WKWebView =  {
        let config = WKWebViewConfiguration.init()
        let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
        let script = WKUserScript.init(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        config.userContentController = userContentController
        let wkWebView = WKWebView.init(frame: .zero, configuration: config)
        wkWebView.scrollView.isScrollEnabled = true
        wkWebView.scrollView.showsVerticalScrollIndicator = false
        wkWebView.scrollView.delegate = self
        wkWebView.scrollView.alwaysBounceVertical = false
        wkWebView.rx.set(delegate: self).disposed(by: disposeBag)
        return wkWebView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.middle.blod
        return titleLabel
    }()
    
    private let discriptionLabel: UILabel = {
        let discriptionLabel = UILabel()
        discriptionLabel.numberOfLines = 1
        discriptionLabel.adjustsFontSizeToFitWidth = true
        return discriptionLabel
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: .gray)
        indicatorView.startAnimating()
        let transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        indicatorView.transform = transform
        return indicatorView
    }()
    
    private var isLoadingFinished: BehaviorRelay<Bool> = .init(value: false)


    var wkViewDidLoad: Driver<Bool> {
        return wkWebView.rx.navigationDidFinish.withLatestFrom(isLoadingFinished.asObservable()).asDriver(onErrorJustReturn: false)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func prepareForReuse() {
        self.reuseableBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubViews()
    }
    
    private func setupSubViews() {
        setupNmBindingWith(cells: self)
        setupNmBindingWith(normalLabels: titleLabel)
        self.addSubview(portraitButton)
        self.addSubview(titleLabel)
        self.addSubview(discriptionLabel)
        self.addSubview(indicatorView)
        self.addSubview(wkWebView)
        
        
        wkViewDidLoad.drive(indicatorView.rx.isHidden).disposed(by: disposeBag)
        
        //layout
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(8)
            maker.left.equalToSuperview().offset(8)
            maker.right.equalToSuperview().offset(-8)
        }
        
        portraitButton.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(8)
            maker.top.equalTo(titleLabel.snp.bottom).offset(8)
            maker.height.equalTo(20)
            maker.width.equalTo(20)
        }
        
        indicatorView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(discriptionLabel.snp.centerY)
            maker.left.equalTo(discriptionLabel.snp.right)
        }
        
        discriptionLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(portraitButton.snp.right).offset(8)
            maker.centerY.equalTo(portraitButton.snp.centerY)
            //限制discriptionLabel的宽，这样做比较好
            let maxHeight = CGFloat.screenWidth - 20 - 16 - 24
            maker.width.lessThanOrEqualTo(maxHeight)
        }
        
    
        wkWebView.snp.makeConstraints { (maker) in
            maker.top.equalTo(portraitButton.snp.bottom).offset(1)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview().offset(0)
        }
        
        


    }
    
    func render(html: String?) {
        wkWebView.loadHTMLString(html ?? "", baseURL: nil)
        
    }
    
    func render(attributedString: NSAttributedString?) {
        discriptionLabel.attributedText = attributedString
        
    }
    
    func render(imageURL: String?) {
        portraitButton.sd_setBackgroundImage(with: URL(string: imageURL ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "tx"))
    }
    
    func render(string: String?) {
        titleLabel.text = string
    }
    
    func handleHtml<O: ObservableType>(withViewHeightHandler handler: @escaping (CGFloat)->() ) -> (_ source: O) -> Disposable where O.Element == Bool {
        return { source in
            return source.bind(onNext: { [weak self] (isFinished) in
                guard !isFinished, let self = self else { return }
                self.wkWebView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (result, _) in
                    guard let height = result as? CGFloat else { return }
                    handler(height)
                })
                //避免多次调用获取height后的hanlder
                self.isLoadingFinished.accept(true)
            })
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(.cancel)
            //点击链接的后续逻辑
        }
        else {
            decisionHandler(.allow)
        }
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
