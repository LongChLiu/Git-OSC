//
//  WKWebView+Rx.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/11.
//  Copyright © 2018 Git@OSC. All rights reserved.
//
import WebKit
import RxSwift
import RxCocoa



extension Reactive where Base: WKWebView {
    
    var navigationDelegate: WKNavigationDelegateProxy {
        return WKNavigationDelegateProxy.proxy(for: base)
    }
    
    var navigationDidFinish: ControlEvent<()> {
        return ControlEvent(events: navigationDelegate.methodInvoked(#selector(WKNavigationDelegate.webView(_:didFinish:))).map{ _ in () })
    }
    ///手动设置ForwardDelegate
    func set(delegate: WKNavigationDelegate) -> Disposable {
        return WKNavigationDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
    }
}
