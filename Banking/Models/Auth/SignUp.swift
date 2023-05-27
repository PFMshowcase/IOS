//
//  SignUp.swift
//  Banking
//
//  Created by Toby Clark on 13/5/2023.
//

import Foundation
import LocalAuthentication
import FirebaseAuth


extension Auth {
//    TODO: If user creation fails after firebase user has been made, delete firebase user as well as any created data
    func createUser (username: String, password: String, name: UsersName, pin: String? = nil, biometrics: AuthBiometricFlag = .noBiometrics) throws -> Void {
        guard self.current == nil else {
            throw AuthError.alreadySignedIn
        }
        
//        If successful then add keychain and user defaults
        let available_auth_methods = try create_local_sign_in(username: username, password: password, pin: pin, biometrics: biometrics)
                
        if self.preview {
            try Auth.add_available_sign_in_methods(available_auth_methods)
            self.current = UserDetails(preview: true)
            return
        }
        
//        Create firebase user
        try create_firebase_user(username: username, password: password)
        
        try Auth.add_available_sign_in_methods(available_auth_methods)
        self.current = UserDetails()
    }
    
    private func create_local_sign_in (username: String, password: String, pin: String? = nil, biometrics: AuthBiometricFlag = .noBiometrics) throws -> [AuthSignInMethods] {
        var available_auth_methods: [AuthSignInMethods] = [.password]
        
//        If pin has been created then add that method of auth
        if pin != nil {
            try self.manageKeychain(.create, attr_account: username, value_data: pin!.data(using: .utf8)!, attr_service: .pin)
            available_auth_methods.append(.pin)
        }
        
//        If enable biometrics is true then add that method of auth
        if biometrics == .biometrics {
            available_auth_methods.append(.biometric)
        }
                
//        Writing username and password to keychain for use with
//        local authentication methods (pin, biometrics)
        try self.manageKeychain(.create, attr_account: username, value_data: password.data(using: .utf8)!, attr_service: .password)
        
        return available_auth_methods
    }
    
    private func create_firebase_user (username: String, password: String) throws {
        var firebase_err: Error?

        FirebaseAuth.Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            guard error == nil else {
                firebase_err = error
                return
            }
            print("success")
        }

        if firebase_err != nil {
            throw firebase_err!
        }
    }
    
    func enableBiometrics () -> Bool {
        let context = LAContext()
        var policy_error: NSError?
        var reason = "Enable using "
        var res = false
        
        let available = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &policy_error)
        
        if !available {
            return false
        }
        
        let biometrics_type = context.biometryType
        
        if biometrics_type == .faceID {
            reason += "faceID to sign in"
        } else if biometrics_type == .touchID {
            reason += "touchID to sign in"
        } else {
            return false
        }
        
//        Authenticating with face id so that swift can ask for
//        users permission and confirm that they can pass successfully
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            if success {
                res = true
            }
        }
        
        return res
    }
}
