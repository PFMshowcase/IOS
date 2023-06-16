//
//  Signing.swift
//  Banking
//
//  Created by Toby Clark on 13/5/2023.
//

import Foundation
import LocalAuthentication
import FirebaseAuth
import FirebaseSharedSwift
import FirebaseFunctions


/* =====================================================
 
    Auth extension with sign in and create user funcs
 
   ===================================================== */

extension Auth {
//    Base sign in func, takes username and password and signs into
//    Firebase and retrieves the basiq user id
    func signIn (username: String, password: String) async throws -> Void {
        guard self.user == nil else {
            throw AuthError.alreadySignedIn()
        }
        
        if self.preview { self.user = try User(preview: true) }
        
        try await FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password)
                                
//        Have to call with data of some sort when using decoder
//        Not sure best way to do this
        let decoder = FirebaseDataDecoder()
        decoder.dateDecodingStrategy = .timestamp
        let res = try await functions.httpsCallable("callable-loginuser", requestAs: String.self, responseAs: DecodableDBUser.self, decoder: decoder).call("")
                
        print("username: "+username + " - password: " + password)
        try await User.create(res)
        Auth.set_last_user(username)
    }
    
//    Sign in func to enable signing in with a pin and grabbing the
//    values from keychain
    func signIn (pin: String) async throws -> Void {
        guard let last_logged_in = Auth.get_last_user() else { throw AuthError.generic() }
        
        let (_, defined_pin) = try manageKeychain(.read, attr_account: last_logged_in, attr_service: .pin)
        
        guard pin == defined_pin else { throw AuthError.incorrectPin() }
        
        let (username, pswrd) = try manageKeychain(.read, attr_account: last_logged_in, attr_service: .password)
        
        try await self.signIn(username: username, password: pswrd)
    }
    
    func signIn (_ biometric: AuthBiometricFlag) async throws -> Void {
//        Check if biometric is face or touch
//        Use that method to prompt signing in
//        If successful grab details from keychain 
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { throw AuthError.biometricsNotAvailable() }

        let reason = "Easy method for logging in!"
        
        let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
        
        guard success else { throw AuthError.biometricAuthFailed() }
        guard let last_user_logged_in = Auth.get_last_user(),
              let (username, pswrd) = try? self.manageKeychain(.read, attr_account: last_user_logged_in, attr_service: .password)
        else { throw AuthError.generic() }
        
        try await self.signIn(username: username, password: pswrd)
    }
}
