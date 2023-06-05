//
//  Utils.swift
//  Banking
//
//  Created by Toby Clark on 11/5/2023.
//

import Foundation
import FirebaseFirestore
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

@objc class UsersName: NSObject, ObservableObject {
    @Published var fName: String
    @Published var lName: String
    @Published var display: String?
    
    var toDict: [String:Any] {
        ["fName": fName, "lName": lName, "display": display as Any]
    }
    
    init (fName: String, lName: String, display: String? = nil) {
        self.fName = fName
        self.lName = lName
        self.display = display
    }
    
    init? (dict: [String: Any]?) {
        guard let _fName = dict?["fName"] as? String,
              let _lName = dict?["lName"] as? String else { return nil }
        
        self.fName = _fName
        self.lName = _lName
        self.display = dict?["display"] as? String
    }
}

@objc protocol UserType {
    var email: String { get }
    var name: UsersName { get }
    var total_balance: Double { get }
    var accounts: [Account] { get }
    var transactions: [Transaction] { get }
    var basiq_user: BasiqUser { get }
    var fir_user: FirebaseAuth.User { get }
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
