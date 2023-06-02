//
//  Signing.swift
//  Banking
//
//  Created by Toby Clark on 13/5/2023.
//

import Foundation
import LocalAuthentication
import FirebaseAuth


/* =====================================================
 
    Auth extension with sign in and create user funcs
 
   ===================================================== */

extension Auth {
//    Base sign in func, takes username and password and signs into
//    Firebase and retrieves the basiq user id
    func signIn (username: String, password: String) throws -> Void {
        var fir_err: Error?
        var basiq_user: AuthBasiqUser?
        guard self.current == nil else {
            throw AuthError.alreadySignedIn
        }
        
        if self.preview {
            current = UserDetails(preview: true)
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            fir_err = error
        }
                
        if fir_err != nil { throw fir_err! }
        
        functions.httpsCallable("loginuser").call() { res, err in
            guard err == nil else {
                fir_err = err!
                return
            }
            
            guard let resData = res?.data as? [String: Any],
                  let resUser = AuthBasiqUser(dict: resData) else {
                fir_err = AuthError.generic
                return
            }
            basiq_user = resUser
        }
        
        print("username: "+username + " - password: " + password)
        current = UserDetails(basiq_user: basiq_user!)
        Auth.set_last_user(username)
    }
    
//    Sign in func to enable signing in with a pin and grabbing the
//    values from keychain
    func signIn (pin: String) throws -> Void {
        let encoded_pin = pin.data(using: .utf8)!
        let (defined_acc, defined_pin) = try manageKeychain(.read, value_data: encoded_pin, attr_service: .pin)
        
        guard pin == defined_pin else {
            throw AuthError.incorrectPin
        }
        
        let (username, pswrd) = try manageKeychain(.read, attr_account: defined_acc, attr_service: .password)
        
        try self.signIn(username: username, password: pswrd)
    }
    
    func signIn (_ biometric: AuthBiometricFlag) throws -> Void {
//        Check if biometric is face or touch
//        Use that method to prompt signing in
//        If successful grab details from keychain
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Easy method for logging in!"
            var error: AuthError?
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
//                    TODO: Figure out how to propogate errors here instead of asigning an arbitrary error
                        guard let last_user_logged_in = Auth.get_last_user() else {
                            error = AuthError.generic
                            return
                        }
                        
                        guard let (username, pswrd) = try? self.manageKeychain(.read, attr_account: last_user_logged_in, attr_service: .password) else {
                            error = AuthError.generic
                            return
                        }
                        
                        
                        let res: Void? = try? self.signIn(username: username, password: pswrd)
                        
                        
                        guard res != nil else {
                            error = AuthError.generic
                            return
                        }
                    } else {
                        error = AuthError.biometricAuthFailed
                    }
                }
            }
            
            guard error == nil else {
                throw error!
            }
        } else {
            throw AuthError.biometricsNotAvailable
        }
    }
}
