//
//  SignUp.swift
//  Banking
//
//  Created by Toby Clark on 13/5/2023.
//

import Foundation
import LocalAuthentication
import FirebaseAuth
import FirebaseSharedSwift
import FirebaseFunctions


extension Auth {
//    TODO: If user creation fails after firebase user has been made, delete firebase user as well as any created data
    func createUser (username: String, password: String, name: UsersName, pin: String? = nil, biometrics: AuthBiometricFlag = .noBiometrics) async throws -> Void {
        guard self.user == nil else { throw AuthError.alreadySignedIn() }
        
//        If successful then add keychain and user defaults
        let available_auth_methods = try create_local_sign_in(username: username, password: password, pin: pin, biometrics: biometrics)
                
        if self.preview {
            try Auth.add_available_sign_in_methods(available_auth_methods)
            self.user = try User(preview: true)
            return
        }
        
//        Create Firebase and Basiq user
        let db_user = try await create_fir_basiq_user(username: username, password: password, name: name)
        
        try Auth.add_available_sign_in_methods(available_auth_methods)
        try await User.create(db_user)
        Auth.set_last_user(username)
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
    
    private func create_fir_basiq_user (username: String, password: String, name: UsersName) async throws -> DBUser {
        try await FirebaseAuth.Auth.auth().createUser(withEmail: username, password: password)
        
        let decoder = FirebaseDataDecoder()
        decoder.dateDecodingStrategy = .timestamp
        return try await functions.httpsCallable("callable-setupuser", requestAs: EncodableDBUser.self, responseAs: DecodableDBUser.self, decoder: decoder).call(EncodableDBUser(name: name, email: username))
    }
    
    func enableBiometrics () async throws -> Bool {
        let context = LAContext()
        var policy_error: NSError?
        var reason = "Enable using "
        
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
        
        return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
    }
}
