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
    
    @State var input_pin: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var login_method: AuthSignInMethods
    
    init (_ auth:Auth, _ switch_method: @escaping () -> Void) {
        self.auth = auth
        self.switch_method = switch_method
        
        if preferred_auth != nil && preferred_auth!.contains(.pin) { self._login_method = State(initialValue: .pin) }
        else { self._login_method = State(initialValue: .password) }
    }

    func finish(_ method: AuthSignInMethods) {
        switch method {
        case .biometric: Task { try await auth.signIn(.biometrics) }
        case .password: Task { try await auth.signIn(username:self.email, password:self.password) }
        case .pin: Task {
            do {
                try await auth.signIn(pin:self.input_pin)
            } catch {
                print(error)
                
            }
        }
        default: Task { try await auth.signIn(username: self.email, password: self.password) }
        }
    }
    
    func setLoginMethod(_ method: AuthSignInMethods) {
        self.login_method = method
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("SimpliFunds")
                    .font(.h1)
                Text("Login")
                    .font(.h2)
            }
            .bAlignment(.center)
            
            switch self.login_method {
            case .pin: SignInWithPin(finish: finish, setLoginMethod: setLoginMethod, input_pin: $input_pin)
            default: SignInWithPassword(finish: finish, setLoginMethod: setLoginMethod, email: $email, password: $password)
            }
            
            Button("Create an account", action: switch_method)
                .font(.extraSmall)
        }.onAppear() { if preferred_auth != nil && preferred_auth!.contains(.biometric) { finish(.biometric) } }
    }
}


struct SignInWithPin: View {
    let finish: (AuthSignInMethods) -> Void
    let setLoginMethod: (AuthSignInMethods) -> Void
    @Binding var input_pin: String
    
    var body: some View {
        VStack {
            SecureField("Pin", text: $input_pin)
                .keyboardType(.numberPad)
                .textFieldStyles()
            Button(action: {() in finish(.pin)}, label: { Text("Submit").frame(maxWidth: .infinity) })
                .buttonStyles(CustomColour.secondary.light)
            Button("Login with email", action: {() in setLoginMethod(.password)})
                .font(.small)
        }
    }
    
}

struct SignInWithPassword: View {
    let finish: (AuthSignInMethods) -> Void
    let setLoginMethod: (AuthSignInMethods) -> Void
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyles()
                .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
                .textFieldStyles()
            Button(action: {() in finish(.password)}, label: { Text("Submit").frame(maxWidth: .infinity) })
                .buttonStyles(CustomColour.secondary.light)
            Button("Login with pin", action: {() in setLoginMethod(.pin)})
                .font(.small)
        }
    }
}
