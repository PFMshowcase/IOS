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
    let switch_method: () -> Void
    var biometric: Bool = false
    
    init (_ auth:Auth, _ switch_method: @escaping () -> Void) {
        self.auth = auth
        self.switch_method = switch_method
    }
    
    @State var input_pin: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    func finish(_ method: AuthSignInMethods) {
        switch method {
        case .biometric: Task { try await auth.signIn(.biometrics) }
        case .password: Task { try await auth.signIn(username:self.email, password:self.password) }
        case .pin: Task { try await auth.signIn(pin:self.input_pin) }
        default: Task { try await auth.signIn(username: self.email, password: self.password)}
        }
    }
    
    var body: some View {
        Button("switch", action: switch_method)
        if preferred_auth == nil {
            SignInWithPassword(finish: finish, email: $email, password: $password)
        } else if preferred_auth!.contains(.biometric) {
            SignInWithPin(finish: finish, input_pin: $input_pin)
                .onAppear() {
                    finish(.biometric)
                }
        } else if preferred_auth!.contains(.pin) {
            SignInWithPin(finish: finish, input_pin: $input_pin)
        } else {
            SignInWithPassword(finish: finish, email: $email, password: $password)
        }
    }
}


struct SignInWithPin: View {
    let finish: (AuthSignInMethods) -> Void
    @Binding var input_pin: String
    
    var body: some View {
        VStack {
            Text("pin")
            TextField("Pin", text: $input_pin).autocorrectionDisabled().textInputAutocapitalization(.never)
            Button("Submit", action: {() in finish(.pin)})
        }
    }
    
}

struct SignInWithPassword: View {
    let finish: (AuthSignInMethods) -> Void
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        VStack {
            Text("Email and Password")
            TextField("Email", text: $email).autocorrectionDisabled().textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("Submit", action: {() in finish(.password)})
        }
    }
}
