//
//  BasiqConsentView.swift
//  Banking
//
//  Created by Toby Clark on 7/6/2023.
//

import SwiftUI

struct BasiqConsentView: View {
    @EnvironmentObject var user: User
//    Lol
    @State var url: URL = URL(string: "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjHvuih1uz_AhX4jVYBHfuQD7UQyCl6BAglEAM&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DdQw4w9WgXcQ&usg=AOvVaw0aHtehaphMhOCAkCydRLZU&opi=89978449")!
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
                WebView(url: self.url, finished:self.finished)
                    .scrollDisabled(true)
                    .bAlignment()
            }

        }
        .ignoresSafeArea()
        .onAppear() {
            do {
                try self.url = BasiqApi.api!.getURL(url: "https://consent.basiq.io/home?&token={token}&institutionId=AU00000")
                self.open = true
            } catch {
//                TODO: Toast error?
                print(error.localizedDescription)
            }
        }
    }
}


