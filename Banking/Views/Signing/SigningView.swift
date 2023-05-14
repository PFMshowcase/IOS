//
//  Signing.swift
//  Banking
//
//  Created by Toby Clark on 12/5/2023.
//

import SwiftUI

struct SigningView: View {
    @State var email: String = ""
    @State var password: String = ""
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

struct SignInFlow: View {
    let preferred_auth = Auth.get_available_sign_in_method()
    let auth: Auth
    
    private func userPass () -> some View {
        @State var email: String = ""
        @State var password: String = ""
        
        func sign_in_with_email_pass () {
            do {
                try auth.signIn(username: email, password: password)
            } catch {
//                Handle incorrect email and password (10 attempts before time out?)
                print("error signing in with email and password")
            }
        }
        
        return VStack {
            Text("Email and Password")
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            Button("Submit", action: sign_in_with_email_pass)
        }
    }
    
    private func pin () -> some View {
        @State var input_pin: String = ""
        
        func sign_in_with_pin () {
            do {
                try auth.signIn(pin: input_pin)
            } catch {
//                Handle incorrect pin (5 attempts before reverting to email and pass)
                print("error signing in with pin")
            }
        }
        
        return VStack {
            Text("pin")
            TextField("Pin", text: $input_pin)
            Button("Submit", action: sign_in_with_pin)
        }
    }
    
    var body: some View {
        if preferred_auth == nil {
            userPass()
        } else if preferred_auth!.contains(.biometric) {
            pin()
                .onAppear() {
                    do {
                        try auth.signIn(.biometrics)
                    } catch {
                        print("FaceId failed, reverting to pin")
                    }
                }
        } else if preferred_auth!.contains(.pin) {
            pin()
        } else {
            userPass()
        }
    }
}


//struct Signing_Preview: PreviewProvider {
//    
//    
//    static var previews: some View {
//        Signing(try! Auth.getAuth()).previewLayout(.sizeThatFits)
//    }
//}
