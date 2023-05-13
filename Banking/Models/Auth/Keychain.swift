//
//  Keychain.swift
//  Banking
//
//  Created by Toby Clark on 13/5/2023.
//

import Foundation
import AuthenticationServices

// TODO: Refactor this; too long

/* =====================================================
 
    Auth extension creating CRUD access to device
    keychain
 
   ===================================================== */

extension Auth {    
//    Private func for retrieving stored keychain username/password
    private func manageKeychain (_ method: KeychainMethods.write, account: String, data: Data, attr_label: String) throws {
        query[kSecAttrAccount] = account
        query[kSecAttrLabel] = attr_label
        
        if method == .create {
            query[kSecValueData] = data
            
            let saveStatus = SecItemAdd(query as CFDictionary, nil)
            
            if saveStatus == errSecDuplicateItem {
                try manageKeychain(.update, account: account, data: data, attr_label: attr_label)
            } else if saveStatus != errSecSuccess {
                throw KeychainError.operation
            }
        } else if method == .update {
            let updatedData = [kSecValueData: data]
            
            let updateStatus = SecItemUpdate(query as CFDictionary, updatedData as CFDictionary)
            
            if updateStatus != errSecSuccess {
                throw KeychainError.operation
            }
        }
    }
    
    private func manageKeychain (_ method: KeychainMethods.read, attr_label: String) throws -> (String, String) {
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecAttrLabel] = attr_label
        query[kSecReturnAttributes] = true
        query[kSecReturnData] = true
        
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8)
            {
                return (username, password)
            } else {
                throw KeychainError.valuesNotCorrect
            }
        } else {
            throw KeychainError.operation
        }
    }
    
    private func manageKeychain (_ method: KeychainMethods.delete, attr_label: String) throws {
        query[kSecAttrLabel] = attr_label
        
        let res = SecItemDelete(query as CFDictionary)
        
        if res != errSecSuccess {
            throw KeychainError.operation
        }
    }
}

/* =====================================================
 
    Auth extension with keychain wrappers to access for
    username and password
 
   ===================================================== */

extension Auth {
    internal func getUserPassKeychain () throws -> (username: String, password: String) {
        let res = try manageKeychain(.read, attr_label: "password")
        return res
    }
    
    internal func writeUserPassKeychain (username: String, password: String) throws {
        let data = password.data(using: .utf8)!
        
        try manageKeychain(.create, account: username, data: data, attr_label: "password")
    }
    
    internal func updateUserPassKeychain (username: String, password: String) throws {
        let data = password.data(using: .utf8)!
        
        try manageKeychain(.update, account: username, data: data, attr_label: "password")
    }
    
    internal func deleteUserPassKeychain () throws {
        try manageKeychain(.delete, attr_label: "password")
    }
}

/* =====================================================
 
    Auth extension with keychain wrappers to access for
    pin code
 
   ===================================================== */

extension Auth {
    internal func getPinKeychain () throws -> String {
        let (_, pin) = try manageKeychain(.read, attr_label: "pin")
        return pin
    }
    
    internal func writePinKeychain (pin: String) throws {
        let data = pin.data(using: .utf8)!
        
        try manageKeychain(.create, account: "pin", data: data, attr_label: "pin")
    }
    
    internal func updatePinKeychain (pin: String) throws {
        let data = pin.data(using: .utf8)!
        
        try manageKeychain(.update, account: "pin", data: data, attr_label: "pin")
    }
    
    internal func deletePinKeychain () throws {
        try manageKeychain(.delete, attr_label: "pin")
    }
}
