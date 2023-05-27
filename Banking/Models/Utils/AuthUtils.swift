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

@objc class UsersName: NSObject, ObservableObject {
    @Published var fName: String
    @Published var lName: String
    @Published var display: String?
    
    init(fName: String, lName: String, display: String? = nil) {
        self.fName = fName
        self.lName = lName
        self.display = display
    }
}

@objc protocol UserType {
    var email: String { get }
    var name: UsersName { get }
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

enum KeychainTypes: String {
    case password = "password"
    case pin = "pin"
}

enum KeychainError: Error {
    case operation
    case valuesNotCorrect
    case uuidNeededToUpdate
    case accountOrDataNeeded
}
