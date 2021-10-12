//
//  WKWebViewDelegateProxy.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/11.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import WebKit
import RxSwift
import RxCocoa

class WKNavigationDelegateProxy: DelegateProxy<WKWebView, WKNavigationDelegate>, DelegateProxyType, WKNavigationDelegate {
    
    init(wkWebView: WKWebView) {
        super.init(parentObject: wkWebView, delegateProxy: WKNavigationDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register{ WKNavigationDelegateProxy(wkWebView: $0) }
    }
    
    static func currentDelegate(for object: WKWebView) -> WKNavigationDelegate? {
        return object.navigationDelegate
    }
    
    static func setCurrentDelegate(_ delegate: WKNavigationDelegate?, to object: WKWebView) {
        object.navigationDelegate = delegate
    }
    

}
