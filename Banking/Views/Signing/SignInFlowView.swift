//
//  SignInFlowView.swift
//  Banking
//
//  Created by Toby Clark on 15/5/2023.
//

import Foundation
import SwiftUI

struct SignInFlow: View {
    let preferred_auth = Auth.get_available_sign_in_method()
    let auth: Auth
    
    init (_ auth:Auth) {
        self.auth = auth
    }
    
    @State var input_pin: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    private func userPass () -> some View {
        func sign_in_with_email_pass () {
            do {
                try auth.createUser(username: "test", password: "1234", name: UsersName(fName: "first", lName: "last"))
//                try auth.signIn(username: email, password: password)
            } catch let err{
                print(err)
//                TODO: Handle incorrect email and password (10 attempts before time out?)
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
        func sign_in_with_pin () {
            do {
                try auth.signIn(pin: input_pin)
            } catch {
//                TODO: Handle incorrect pin (5 attempts before reverting to email and pass)
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
