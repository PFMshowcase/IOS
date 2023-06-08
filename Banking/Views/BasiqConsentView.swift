//
//  BasiqConsentView.swift
//  Banking
//
//  Created by Toby Clark on 7/6/2023.
//

import SwiftUI
import WebKit

struct BasiqConsentView: View {
    var user: User
    @State var url: String
    @State var open: Bool
    
    init(user: User) {
        self.user = user
        let token: String = user.basiq_user.token
        self.url = "https://consent.basiq.io/home?token=\(token)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://google.com"
        self.open = true
    }
    
    func finished() {
        Task {
            self.open = false
            try await user.refreshBasiq()
        }
    }
    
    var body: some View {
        if open == true { WebView(url: URL(string: self.url)!, finished:self.finished).scrollDisabled(true) }
    }
}


struct WebView: UIViewRepresentable {
    var url: URL
    var finished: () -> Void
    let source_script: String = "var meta = document.createElement('meta');" +
        "meta.name = 'viewport';" +
        "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
        "var head = document.getElementsByTagName('head')[0];" +
        "head.appendChild(meta);"
    
    func makeUIView(context: Context) -> WKWebView {
        let script = WKUserScript(source: source_script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.userContentController.addUserScript(script)
        
        let webKit = WKWebView(frame: .zero, configuration: conf)
        webKit.navigationDelegate = context.coordinator
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
    }
}
