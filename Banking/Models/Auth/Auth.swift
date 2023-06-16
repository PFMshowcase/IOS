//
//  User.swift
//  Banking
//
//  Created by Toby Clark on 25/4/2023.
//

import Foundation
import FirebaseAuth

/* =====================================================
 
    Singleton Auth Class
 
   ===================================================== */


class Auth: ObservableObject {
//    Singleton vars
    static var auth:Auth?
    
//    Current User & observation
    @Published var user: User? = User.current
    
    private var observation: NSKeyValueObservation?
    
//    Internal vars
    internal var preview: Bool
    
//    Internal query for keychain methods
    internal var query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword
    ]
    
    private init () {
        self.preview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    func updateUser(_ user: User) {
        Task { @MainActor in
            self.user = user
        }
    }
}

/* =====================================================
 
    Static functions for accessing and creating the
    Auth singleton
 
   ===================================================== */

extension Auth {
    //    Check if class has already been initialized before creating new instance
    @discardableResult static func setup () throws -> Auth {
        guard Auth.auth == nil else {
            throw AuthError.alreadyInitialized()
        }
        let new_auth = Auth()
        Auth.auth = new_auth
        return new_auth
    }
    
    //    If class has been initialized return the current user
    static func getAuth () throws -> Auth {
        guard let current_auth = Auth.auth else {
            throw AuthError.notInitialized()
        }
        return current_auth
    }
}

/* =====================================================
 
    Static functions for getting and setting available
    sign in methods from UserDefaults
 
 ===================================================== */

extension Auth {
    private static let defaults = UserDefaults.standard
    
    static func add_available_sign_in_methods (_ methods: [AuthSignInMethods]) throws {
//        Check if it already exists
        var output_methods: [AuthSignInMethods] = methods
        
        if let existing_methods = Auth.get_available_sign_in_method() {
            existing_methods.forEach() { val in
                if !output_methods.contains(val) {
                    output_methods.append(val)
                }
            }
        }
        
        if let encoded = try? JSONEncoder().encode(output_methods) {
            defaults.set(encoded, forKey: "available-sign-in")
        } else {
//            TODO: Throw error
        }
    }

    static func get_available_sign_in_method () -> [AuthSignInMethods]? {
        if let data = defaults.object(forKey: "available-sign-in") as? Data,
           let decoded = try? JSONDecoder().decode([AuthSignInMethods].self, from: data) {
            return decoded
        }
        
        return nil
    }
    
    static func set_last_user (_ username: String) {
        defaults.set(username, forKey: "last-user")
    }
    
    static func get_last_user () -> String? {
        return defaults.string(forKey: "last-user")
    }
}


