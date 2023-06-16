//
//  Signing.swift
//  Banking
//
//  Created by Toby Clark on 12/5/2023.
//

import SwiftUI

struct SigningView: View {
    @State var method: AuthMethods
    @State var test: String = ""
    @EnvironmentObject var auth: Auth
    
    init () {
        let sign_in_preferences = Auth.get_available_sign_in_method()
        
        if sign_in_preferences != nil {
            method = .logIn
        } else {
            method = .create
        }
    }
    
    private func swapMethod () {
        if method == .logIn {
            method = .create
        } else {
            method = .logIn
        }
    }
    
    var body: some View {
        VStack {
            switch method {
            case .create:CreateFlowView(auth, swapMethod)
            case .logIn:SignInFlow(auth, swapMethod)
            }
        }
        .padding([.top, .bottom, .trailing, .leading], 15)
        .bAlignment(.center)
        .foregroundColor(.text.normal)
        .background(.background)
    }
}



//struct Signing_Preview: PreviewProvider {
//
//
//    static var previews: some View {
//        SigningView(try! Auth.getAuth()).previewLayout(.sizeThatFits)
//    }
//}
