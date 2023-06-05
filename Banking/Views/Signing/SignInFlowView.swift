//
//  SignInFlowView.swift
//  Banking
//
//  Created by Toby Clark on 15/5/2023.
//

import Foundation
import SwiftUI

// TODO: Make a single function for handling errors (and maybe dispalying toasts?)

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
            Task {
                do {
                    try await auth.signIn(username: email, password: password)
                } catch let error as AuthError {
                    print(type(of: error))
                    print(error.kind, error.error, error.message as Any)
                } catch {
                    print(error.localizedDescription)
                }
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
            Task {
                do {
                    try await auth.signIn(pin: input_pin)
                } catch let error as AuthError {
                    print(type(of: error))
                    print(error.kind, error.error, error.message as Any)
                } catch {
                    print(error.localizedDescription)
                }
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
                    Task {
                        do {
                            try await auth.signIn(.biometrics)
                        } catch let error as AuthError {
                            print(type(of: error))
                            print(error.kind, error.error, error.message as Any)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
        } else if preferred_auth!.contains(.pin) {
            pin()
        } else {
            userPass()
        }
    }
}
