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
        print(self.url, user.basiq_user.token)
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
    
    func makeUIView(context: Context) -> WKWebView {
        let webKit = WKWebView()
        webKit.navigationDelegate = context.coordinator
        return webKit
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        print(url.absoluteString)
        let request = URLRequest(url: url)
        webView.load(request)
        webView.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = 'input,select:focus, textarea {font-size: 16px !important;}'; document.head.appendChild(style);") { res, err in
            print(err, res)
        }
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
            let urlToMatch = "https://finished-notexistingurl.com"
            
            if let urlStr = navigationAction.request.url?.absoluteString, urlStr == urlToMatch {
                parent.finished()
                decisionHandler(.cancel)
            }
            decisionHandler(.allow)
        }
    }
}
