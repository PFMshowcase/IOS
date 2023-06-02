//
//  Utils.swift
//  Banking
//
//  Created by Toby Clark on 11/5/2023.
//

import Foundation
import FirebaseFirestore

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

struct AuthBasiqUser {
    var id, token: String
    var expiry: Date
    
    init?(dict: [String: Any]) {
        guard let reqId = dict["basiq-uuid"] as? String,
              let reqToken = dict["basiq-token"] as? String,
              let reqExpiry = dict["basiq-token-expiry"] as? Timestamp else { return nil }
        
        self.id = reqId
        self.token = reqToken
        self.expiry = reqExpiry.dateValue()
    }
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
    case unhandled(String)
    case unexpectedValues
    case uuidNeededToUpdate
    case accountOrDataNeeded
}
