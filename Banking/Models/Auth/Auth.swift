//
//  User.swift
//  Banking
//
//  Created by Toby Clark on 25/4/2023.
//

import Foundation
import FirebaseCore

/* =====================================================
 
    Singleton Auth Class
 
   ===================================================== */


class Auth: NSObject, ObservableObject {
//    Singleton vars
    private static var singleton:Auth?
    
//    Current User & observation
    @Published @objc dynamic var current: UserType? = nil
    private var observation: NSKeyValueObservation?
    
//    Internal vars
    internal var basiq_token: String
    internal var preview: Bool = false
    
//    Internal query for keychain methods
    internal var query: [CFString: Any] = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: "PFM"
    ]
    
    private init (basiq_api_key: String) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            self.preview = true
            self.basiq_token = ""
        } else {
    //        Get a basiq_token
            self.basiq_token = "token from api key"
            
            
        }
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
    @discardableResult static func initialize (basiq_api_key: String) throws -> Auth {
        guard Auth.singleton == nil else {
            throw AuthError.alreadyInitialized
        }
        let new_auth = Auth(basiq_api_key: basiq_api_key)
        Auth.singleton = new_auth
        return new_auth
    }
    
    //    If class has been initialized return the current user
    static func getAuth () throws -> Auth {
        guard let current_auth = Auth.singleton else {
            throw AuthError.notInitialized
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
 
 Internal factory for creating the current users details
 
 ===================================================== */

extension Auth {
//    TODO: Connect to Firebase API to get user information and Basiq's API to manage users fincance
//    TODO: Use cloud functions to obscure the API key, pass firebase auth state to the function to ensure the user is authenticated
    
    internal class UserDetails : NSObject, UserType {
        //    Class atributes
        private(set) var email: String
        private(set) var name: UsersName
        private(set) var uid: String
        private(set) var totalBalance: Double
        private(set) var accounts: [Account]
        private(set) var transactions: [Transaction]
        
        init (firebase_auth: Any? = nil, preview: Bool = false) {
            
            //        Change this just to if preview once stubs have been removed
            self.email = "example@example.com"
            self.name = UsersName(fName: "first", lName: "last")
            self.uid = "randomUID"
            self.totalBalance = 20000
            self.accounts = [Account(provider: "Hooli", type: "Mortgage Account", name: "House Mortgage", funds: 19023.23, balance: 19035.22, monthlyIncrease: 0.4, colour: .secondary.base, logo: URL(string:"https://d388vpyfrt4zrj.cloudfront.net/AU00000.svg")), Account(provider: "Qbasic", type: "Savings", name: "savings account", funds: 10104.58, balance: 10900.23, monthlyIncrease: 0.6, colour: .primary.light, logo:URL(string:"https://d388vpyfrt4zrj.cloudfront.net/AU00001.svg"))]
            self.transactions = [Transaction(merchant: "7 Eleven", merchantDetail: "Manly Maths Tutor Wages", merchantWebsite: "website.com", location: "Manly, NSW", imageLink: "linkToImg", amount: -100.08),Transaction(merchant: "Caltex", merchantDetail: "Non Hooli ATM Withdrawal Fee", merchantWebsite: "website.com", location: "Turramurra, NSW", imageLink: "linkToImg", amount: -50.02),Transaction(merchant: "Afterpay", merchantDetail: "AGL RETAIL ENERGY LTD (GAS)", merchantWebsite: "website.com", location: "Epping, NSW", imageLink: "linkToImg", amount: 399.99)]
            
        }
    }
}
