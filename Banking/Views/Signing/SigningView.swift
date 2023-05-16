//
//  Signing.swift
//  Banking
//
//  Created by Toby Clark on 12/5/2023.
//

import SwiftUI

struct SigningView: View {
    @State var method: AuthMethods
    var auth: Auth
    
    init (_ auth_obj: Auth) {
        auth = auth_obj
        
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
            Text("Signing flow")
                .font(.largeTitle)
                .hAlignment(.center)
            switch method {
            case .create:Text("Create account")
            case .logIn:SignInFlow(auth: auth)
            }
            HStack {
                Button(action: swapMethod) {
                    if method == .logIn {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .foregroundColor(.secondary.base)
                    } else {
                        Text("Already have an account?")
                        Text("Sign in")
                            .foregroundColor(.secondary.base)
                    }
                }
            }
            .font(.extraSmall)
            .hAlignment(.center)
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
//        Signing(try! Auth.getAuth()).previewLayout(.sizeThatFits)
//    }
//}
