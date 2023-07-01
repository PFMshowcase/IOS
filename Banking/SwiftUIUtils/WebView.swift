//
//  WebView.swift
//  Banking
//
//  Created by Toby Clark on 30/6/2023.
//

import Foundation
import WebKit
import SwiftUI

class LoggingMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    var finished: () -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.userContentController.add(LoggingMessageHandler(), name: "logging")
        conf.userContentController.addUserScript(WKUserScript(source: getTextFile("ForwardLogsToConsole"), injectionTime: .atDocumentStart, forMainFrameOnly: true))
        
        let webKit = WKWebView(frame: .zero, configuration: conf)
        webKit.navigationDelegate = context.coordinator
        webKit.scrollView.contentInsetAdjustmentBehavior = .never
        webKit.scrollView.contentInset = .zero
        return webKit
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }
    
    class WebViewCoordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        let scrolling_css: String = """
            javascript:(function() {
                let meta = document.createElement('meta');
                meta.name = 'viewport';
                meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
                let head  = document.getElementsByTagName('head')[0];
                head.appendChild(meta);
            })()
        """
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let urlToMatch = "finished-notexistingurl.com"
            if (navigationAction.navigationType == .other) {
                if let redirectedUrl = navigationAction.request.url, redirectedUrl.host == urlToMatch{
                    parent.finished()
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(getTextFile("WebViewPadding"))
            webView.evaluateJavaScript(self.scrolling_css)
        }
    }
}


