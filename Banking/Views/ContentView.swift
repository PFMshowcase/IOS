//
//  ContentView.swift
//  Banking
//
//  Created by Toby Clark on 12/4/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var auth: Auth = try! Auth.getAuth()
    
    var body: some View {
        if auth.user != nil {
            if auth.user!.connections_needed || auth.user!.consent_needed {
                BasiqConsentView()
                    .environmentObject(auth)
                    .environmentObject(auth.user!)
            } else {
                TabBarView()
                    .environmentObject(auth.user!)
                    .environmentObject(auth)
            }
        } else {
            SigningView()
                .environmentObject(auth)
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.sizeThatFits)
    }
}

