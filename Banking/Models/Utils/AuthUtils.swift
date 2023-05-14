//
//  Utils.swift
//  Banking
//
//  Created by Toby Clark on 11/5/2023.
//

import Foundation

/* =====================================================
 
    Auth Types and Errors
 
   ===================================================== */


enum AuthError: Error {
    case alreadyInitialized
    case notInitialized
    case alreadySignedIn
    case incorrectPin
    case biometricAuthFailed
    case biometricsNotAvailable
    case generic
}

enum AuthMethods {
    case logIn
    case create
}

enum AuthBiometricFlag {
    case biometrics
}

enum AuthSignInMethods {
    case biometric
    case password
    case pin
}

@objc protocol UserType {
    var email: String { get }
    var name: String { get }
    var uid: String { get }
    var totalBalance: Double { get }
    var accounts: [Account] { get }
    var transactions: [Transaction] { get }
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

enum KeychainError: Error {
    case operation
    case valuesNotCorrect
}
