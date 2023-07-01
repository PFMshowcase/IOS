//
//  BasiqConsentView.swift
//  Banking
//
//  Created by Toby Clark on 7/6/2023.
//

import SwiftUI

struct BasiqConsentView: View {
    @EnvironmentObject var user: User
    @State var url: String = ""
    @State var open: Bool = false
    
    func finished() {
        Task {
            self.open = false
            try await user.refreshBasiq()
        }
    }
    
    var body: some View {
        ZStack {
            if open == true {
                WebView(url: URL(string: self.url)!, finished:self.finished)
                    .scrollDisabled(true)
                    .bAlignment()
            }

        }
        .ignoresSafeArea()
        .onAppear() {
            let token: String = user.basiq_user.token
            self.url = "https://consent.basiq.io/home?token=\(token)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://google.com"
            self.open = true
        }
    }
}


