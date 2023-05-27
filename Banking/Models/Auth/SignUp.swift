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
    func createUser (username: String, password: String, name: UsersName, pin: String? = nil, biometrics: AuthBiometricFlag = .noBiometrics) throws -> Void {
        guard self.current == nil else {
            throw AuthError.alreadySignedIn
        }
        var available_auth_methods: [AuthSignInMethods] = [.password]
        
//        Create firebase user
//        try createFirebaseUser(username: username, password: password, name: name)
        
//        If successful then add keychain and user defaults
        
//        If pin has been created then add that method of auth
        if pin != nil {
            try self.manageKeychain(.create, attr_account: username, value_data: pin!.data(using: .utf8)!, attr_type: .pin)
            available_auth_methods.append(.pin)
        }
        
//        If enable biometrics is true then add that method of auth
        if biometrics == .biometrics {
            available_auth_methods.append(.biometric)
        }
                
//        Writing username and password to keychain for use with
//        local authentication methods (pin, biometrics)
        try self.manageKeychain(.create, attr_account: username, value_data: password.data(using: .utf8)!, attr_type: .password)
                
        if self.preview {
            try Auth.add_available_sign_in_methods(available_auth_methods)
            self.current = UserDetails(preview: true)
            return
        }
        
        try Auth.add_available_sign_in_methods(available_auth_methods)
        self.current = UserDetails()
    }
    
    private func createFirebaseUser (username: String, password: String, name: UsersName) throws {
//        1. Create user with Firebase Auth create user
//        3. Create Basiq user through Firebase cloud functions (callable)
//        4. Same cloud functions should create a
//           Firebase Firestore entry with user id containing basiq userId, name
//           and any other data and then return the basiq userid
//
        var firebase_err: Error?

        FirebaseAuth.Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            guard error == nil else {
                firebase_err = error
                return
            }
            guard authResult == nil else {
                print(authResult as Any)
                
                firebase_err = AuthError.generic
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
