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
    func createUser (username: String, password: String, name: String, pin: String? = nil, biometrics: AuthBiometricFlag = .noBiometrics) throws -> Void {
        guard self.current == nil else {
            throw AuthError.alreadySignedIn
        }
        var available_auth_methods: [AuthSignInMethods] = [.password]
        
//        If pin has been created then add that method of auth
        if pin != nil {
            try writePinKeychain(pin: pin!)
            available_auth_methods.append(.pin)
        }
        
//        If enable biometrics is true then add that method of auth
        if biometrics == .biometrics {
            available_auth_methods.append(.biometric)
        }
        
//        Writing username and password to keychain for use with
//        local authentication methods (pin, biometrics)
        try writeUserPassKeychain(username: username, password: password)
        
        if self.preview {
            Auth.create_available_sign_in_method(available_auth_methods)
            self.current = UserDetails(preview: true)
            return
        }
        

//        Create user using cloud blocking function, adding their displayName and basiq uuid, this function will create a Basiq user with a server token
        var firebase_err: Error?
        
        FirebaseAuth.Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            guard error == nil else {
                firebase_err = error
                return
            }
            guard authResult == nil else {
                firebase_err = AuthError.generic
                return
            }
        }
        
        if firebase_err != nil {
            throw firebase_err!
        }
        
        let add_details = FirebaseAuth.Auth.auth().currentUser?.createProfileChangeRequest()
        
        add_details?.displayName = name
        add_details?.commitChanges(completion: {(error) in
            if let error = error {
//                TODO: Throw error so that the view can try a new
//                displayname - this part is required for basiq
                print(error.localizedDescription)
            }
        })
        
        Auth.create_available_sign_in_method(available_auth_methods)
        self.current = UserDetails()
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
