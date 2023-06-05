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


class Auth: NSObject, ObservableObject {
//    Singleton vars
    static var auth:Auth?
    
//    Current User & observation
    @Published @objc dynamic var current: UserType? = nil
    private var observation: NSKeyValueObservation?
    
//    Internal vars
    internal var preview: Bool
    
//    Internal query for keychain methods
    internal var query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword
    ]
    
    private override init () {
        self.preview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

/* =====================================================
 
    Creating an observer function which will call a
    provided function when self.current changes
 
   ===================================================== */
    
extension Auth {
    func subscribeToAuthUpdates (_ observer_func: @escaping (Auth)->Void) {
        self.observation = observe(\.current, options: [.new]) { object, change in
            observer_func(try! Auth.getAuth())
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

/* =====================================================
 
 Internal class for managin gthe current users details
 
 ===================================================== */

extension Auth {
//    TODO: This class should be seperate from the Auth class and should handle the user information
    internal class UserDetails : NSObject, UserType {
        private(set) var email: String
        private(set) var name: UsersName
        private(set) var total_balance: Double
        private(set) var accounts: [Account]
        private(set) var transactions: [Transaction]
        private(set) var basiq_user: BasiqUser
        private(set) var fir_user: FirebaseAuth.User
        
        init (basiq_user: BasiqUser, name: UsersName) throws {
            guard let fir_auth = FirebaseAuth.Auth.auth().currentUser else { throw AuthError.unAuthenticated() }
            
            self.fir_user = fir_auth
            self.basiq_user = basiq_user
            self.email = fir_auth.email!
            self.name = name
//            TODO: Grab these details from the basiq api
            self.total_balance = 20000
            self.accounts = [Account(provider: "rand", type: "mortgage", name: "name", funds: 20000, balance: 1200, monthlyIncrease: 200, colour: .bg)]
            self.transactions = [Transaction(merchant: "test", merchantDetail: "test", merchantWebsite: "test.com", location: "test", imageLink: "yurl", amount: 1020)]
            
            let basiq = try BasiqApi.initialize(basiq_user)
            
            try basiq.req("users/{id}", method: .get) { (data: TestBasiqUser?, err) in
                print(err)
                print(data?.id, data?.type, data?.name, data?.email)
            }
        }
        
        init (preview: Bool) throws {
            throw AuthError.notImplemented()
        }
        
    }

}


struct TestBasiqUser: Decodable {
    var id, type: String
    var email, name: String?
}


