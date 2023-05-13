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
    
    //    Class vars
    @Published @objc dynamic var current: UserType? = nil
    private var observation: NSKeyValueObservation?
    private var basiq_token: String
    private var preview: Bool = false
    
    private init (basiq_api_key: String) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            self.preview = true
            self.basiq_token = ""
        } else {
            //        Get a basiq_token
            self.basiq_token = "token from api key"
            
            //        Initialize firebase
            FirebaseApp.configure()
        }
    }
}

/* =====================================================
 
    Auth extension adding the ability to call functions
    when Auth.current updates
 
   ===================================================== */
    
extension Auth {
    func subscribeToAuthUpdates (_ observer_func: @escaping (Auth)->Void) {
        self.observation = observe(\.current, options: [.new]) { object, change in
            observer_func(try! Auth.getAuth())
        }
    }
}

/* =====================================================
 
    Auth extension with sign in and create user funcs
 
   ===================================================== */

extension Auth {
    func signIn (username: String, password: String) throws -> Void {
        guard self.current == nil else {
            throw AuthError.alreadySignedIn
        }
        
        if self.preview {
            print("test " + username + password)
            current = UserDetails(preview: true)
        }
        
//        Sign into GCP identity, will return an auth object which we can pass to UserDetails
//        Information needed:
//            - email: String
//            - display_name: String
//            - basiq_user_id: String
//            - firebase_user_id: String
        print("username: "+username + " - password: " + password)
        current = UserDetails()
    }
    
    func createUser (username: String, password: String, name: String) throws -> Void {
        guard self.current == nil else {
            throw AuthError.alreadySignedIn
        }
        
        if self.preview {
            self.current = UserDetails(preview: true)
        }
//        Create a basiq user
        
//        Create user using cloud blocking function, adding their displayName and basiq uuid
        self.current = UserDetails()
    }
}

/* =====================================================
 
    Extending Auth to add singleton functions
 
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
 
    Private factory for creating the current users details
 
   ===================================================== */

private class UserDetails : NSObject, UserType {
    init (preview: Bool = false) {
        
//        Change this just to if preview once stubs have been removed
        self.email = "example@example.com"
        self.name = "Bob"
        self.uid = "randomUID"
        self.totalBalance = 20000
        self.accounts = [Account(provider: "Hooli", type: "Mortgage Account", name: "House Mortgage", funds: 19023.23, balance: 19035.22, monthlyIncrease: 0.4, colour: .secondary.base, logo: URL(string:"https://d388vpyfrt4zrj.cloudfront.net/AU00000.svg")), Account(provider: "Qbasic", type: "Savings", name: "savings account", funds: 10104.58, balance: 10900.23, monthlyIncrease: 0.6, colour: .primary.light, logo:URL(string:"https://d388vpyfrt4zrj.cloudfront.net/AU00001.svg"))]
        self.transactions = [Transaction(merchant: "7 Eleven", merchantDetail: "Manly Maths Tutor Wages", merchantWebsite: "website.com", location: "Manly, NSW", imageLink: "linkToImg", amount: -100.08),Transaction(merchant: "Caltex", merchantDetail: "Non Hooli ATM Withdrawal Fee", merchantWebsite: "website.com", location: "Turramurra, NSW", imageLink: "linkToImg", amount: -50.02),Transaction(merchant: "Afterpay", merchantDetail: "AGL RETAIL ENERGY LTD (GAS)", merchantWebsite: "website.com", location: "Epping, NSW", imageLink: "linkToImg", amount: 399.99)]
        
    }
    
    
    //    Class atributes
    private(set) var email: String
    private(set) var name: String
    private(set) var uid: String
    private(set) var totalBalance: Double
    private(set) var accounts: [Account]
    private(set) var transactions: [Transaction]
}
    

