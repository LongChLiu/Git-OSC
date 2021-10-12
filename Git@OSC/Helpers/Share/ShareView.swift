//
//  ShareView.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/27.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import MonkeyKing

extension MonkeyKing.Error {
    var description: String {
        switch self {
        case .resource(.invalidImageData): return "无效的图片数据"
        case .userCancelled: return "用户取消"
        default: return "您没有安装%@"
        }
    }
}

class ShareView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    
    private var shareInfo: MonkeyKing.Info?
    
    private var resultHandler: ((String) -> ())?
    
    @IBOutlet var textLabels: [UILabel]!
    
    private var bottomView: UIView?
    
    override func awakeFromNib() {}
    
    static let shared: ShareView = {
       return Bundle.main.loadNibNamed("ShareView", owner: nil, options: nil)?.first as! ShareView
    }()
    
    func set(shareInfo: MonkeyKing.Info, resultHandler: @escaping (String) -> ()) {
        self.shareInfo = shareInfo
        self.resultHandler = resultHandler
    }
    
    func set(contentBackgroundColor: UIColor, textColor: UIColor) {
        contentView.backgroundColor = contentBackgroundColor
        textLabels.forEach { $0.textColor = textColor }
        bottomView?.backgroundColor = contentBackgroundColor
    }
    
    
     func addToMainWindow() {
        guard let mainWindow = UIApplication.shared.keyWindow else {
            return
        }
        mainWindow.addSubview(self)
        self.snp.makeConstraints({  (maker) in
            maker.leading.trailing.equalToSuperview()
            if #available(iOS 11, *) {
                maker.top.equalTo(mainWindow.safeAreaLayoutGuide.snp.top)
                maker.bottom.equalTo(mainWindow.safeAreaLayoutGuide.snp.bottom)
            }
            else {
                maker.top.equalTo(mainWindow.snp.top)
                maker.bottom.equalTo(mainWindow.snp.bottom)
            }
        })
        
        if isIphoneX {
            bottomView = UIView()
            mainWindow.addSubview(bottomView!)
            bottomView?.snp.makeConstraints({ (maker) in
                maker.bottom.leading.trailing.equalToSuperview()
                maker.top.equalTo(self.snp.bottom)
            })
        }
        
        bottomView?.backgroundColor = contentView.backgroundColor

        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.contentView.addY(-CGFloat.screenWidth * 0.7)
        }, completion: nil)
    }
    
    
    @IBAction private func shareActions(_ sender: UIButton) {
        guard let shareInfo = self.shareInfo else {
            fatalError()
        }
        
        var message: MonkeyKing.Message?
        var appName: String?
        switch sender.tag {
        case 0:
            message = MonkeyKing.Message.weChat(.timeline(info: shareInfo))
            appName = "微信"
        case 1:
            message = MonkeyKing.Message.weChat(.session(info: shareInfo))
            appName = "微信"
        case 2:
            message = MonkeyKing.Message.qq(.friends(info: shareInfo))
            appName = "QQ"
        case 3:
            appName = "微博"
            //没有安装weibo则需要accessToken
            message = MonkeyKing.Message.weibo(.default(info: shareInfo, accessToken: nil))
        case 4: openURLInfoInSafari()
        case 5: copyURLInfoToPasteboard()
        default: break
        }
        if let message = message, let appName = appName, let resultHandler = resultHandler  {
            MonkeyKing.deliver(message) {(result) in
                switch result {
                case .failure(let error):
                    resultHandler(String(format: error.description, appName))
                case .success(_):
                    resultHandler("分享成功")
                }
            }
        }
    }
    
     @IBAction private func didCancelButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
        self.bottomView?.removeFromSuperview()
        self.shareInfo = nil
        self.resultHandler = nil
    }
    
    private var sharedURL: URL? {
        guard let media = shareInfo?.media else { return nil }
        switch media {
        case .url(let url): return url
        default: return nil
        }
    }
    
    private func openURLInfoInSafari() {
        guard let url = sharedURL else { return }
        UIApplication.shared.open(url, options: [:]) { [weak self] (success) in
            if let handler = self?.resultHandler, !success { handler("打开浏览器失败") }

        }
    }
    
    private func copyURLInfoToPasteboard() {
        guard let urlString = sharedURL?.absoluteString else { return }
        UIPasteboard.general.string = urlString
        if let handler = self.resultHandler { handler("已复制到剪切板") }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
