//
//  Keychain.swift
//  Banking
//
//  Created by Toby Clark on 13/5/2023.
//

import Foundation
import AuthenticationServices

/* =====================================================
 
    Auth extension creating CRUD access to device
    keychain
 
   ===================================================== */

extension Auth {
    /**
     Method for creating and updating data on the keychain
     
     To enable biometrics and pin numbers, this method will create a keychain entry which stores the users
     preferred username, password and pin. This will enable the app to retrieve the users username and password
     when logging into the app.
    
     - Parameter method: Default parameter specifying whether to create or update or call a different function
     - Parameter attr_account: The username connected to the account
     - Parameter attr_type: the type of the data stored (password/pin)
     - Parameter value_data: the password/pin connected to the account
     
     - Returns: Void
     
     - Throws: `KeychainError` if SecItemAdd or SecItemUpdate don't return SecSuccess
     */
    func manageKeychain (_ method: KeychainMethods.write, attr_account: String, value_data: Data, attr_service: KeychainTypes) throws {
        var res: OSStatus = errSecUnimplemented
        
        query[kSecAttrAccount as String] = attr_account
        query[kSecAttrService as String] = attr_service.rawValue
        
        if method == .create {
            query[kSecValueData as String] = value_data
            
            res = SecItemAdd(query as CFDictionary, nil)
        } else if method == .update {
            let updatedData = [kSecValueData as String: value_data]
            
            res = SecItemUpdate(query as CFDictionary, updatedData as CFDictionary)
        }
        
        guard res == errSecSuccess else { throw KeychainError.unhandled(SecCopyErrorMessageString(res, nil)! as String) }
    }
    
    /**
     Method for reading keychain values
     
     This method takes *either* the account or the data value and searches keychain for the other. Ensure to specify
     whether to return a pin or username and password
     
     - Parameter method: Default parameter specifying whether to read or call a different function
     - Parameter attr_type: The type of value stored, ie: pin or password
     - Parameter attr_account: The provided username for the account to sign in
     
     - Throws: `KeychainError` if data is inputted correctly or operation fails
     
     - Returns: Tuple with the username and then the password/pin of the account
     */
    func manageKeychain (_ method: KeychainMethods.read, attr_account: String? = nil, value_data: Data? = nil, attr_service: KeychainTypes) throws -> (String, String) {
        guard attr_account != nil || value_data != nil else { throw KeychainError.accountOrDataNeeded }
        
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = true
        query[kSecReturnData as String] = true
        query[kSecAttrService as String] = attr_service.rawValue
        
        if attr_account != nil {
            query[kSecAttrAccount as String] = attr_account
        } else if value_data != nil {
            query[kSecValueData as String] = value_data
        }
        
        var item: CFTypeRef?
                
        let res = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard res == noErr else { throw KeychainError.unhandled(SecCopyErrorMessageString(res, nil)! as String) }
        
        guard let existingItem = item as? [String: Any],
              let account = existingItem[kSecAttrAccount as String] as? String,
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: .utf8)
        else {
            throw KeychainError.unexpectedValues
        }
        
        return (account, password)
    }
    
    /**
     Method for deleting keychain values
     
     This method takes either the account or the data value and searches keychain for the other. Ensure to specify
     whether to return a pin or username and password
     
     - Parameter method: Default parameter specifying whether to delete or call a different function
     - Parameter attr_type: The type of value stored, ie: pin or password
     - Parameter attr_account: The provided username for the account to sign in
     
     - Throws: `KeychainError` if operation fails
     
     - Returns: Void
     */
    func manageKeychain (_ method: KeychainMethods.delete, attr_account: String, attr_service: KeychainTypes) throws {
        query[kSecAttrAccount as String] = attr_account
        query[kSecAttrService as String] = attr_service
        
        let res = SecItemDelete(query as CFDictionary)
        
        guard res == errSecSuccess else { throw KeychainError.unhandled(SecCopyErrorMessageString(res, nil)! as String)}
    }
}
