//
//  Utils.swift
//  Banking
//
//  Created by Toby Clark on 11/5/2023.
//

import Foundation
import FirebaseAuth

/* =====================================================
 
    Auth Types and Errors
 
   ===================================================== */

enum AuthMethods {
    case logIn
    case create
}

enum AuthBiometricFlag {
    case biometrics
    case noBiometrics
}

struct AuthSignInMethods: Codable, Equatable {
    static let biometric = AuthSignInMethods("biometric")
    static let password = AuthSignInMethods("password")
    static let pin = AuthSignInMethods("pin")
    
    var value: String
    
    init (_ type: String) {
        value = type
    }
}


/* =====================================================
 
    Keychain Types and Errors
 
   ===================================================== */

struct KeychainMethods {
    enum write {
        case create
        case update
    }
    
    enum read {
        case read
    }
    
    enum delete {
        case delete
    }
}

enum KeychainTypes: String {
    case password = "password"
    case pin = "pin"
}
