//
//  ContentView.swift
//  Banking
//
//  Created by Toby Clark on 12/4/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var auth: Auth = try! Auth.getAuth()
    
    private func authUpdate(new: Auth) {
        print("Does this work?")
    }
    
    var body: some View {
        VStack {
            if let current = auth.current {
                Home(current)
            } else {
                Signing(auth: auth)
            }
        }.onAppear {
            
        }
        
    }
    
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.sizeThatFits)
    }
}

