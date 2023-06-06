//
//  User.swift
//  Banking
//
//  Created by Toby Clark on 6/6/2023.
//

import Foundation
import FirebaseAuth


class User : NSObject, UserType {
    private(set) var email: String
    private(set) var name: UsersName
    private(set) var total_balance: Double
    private(set) var accounts: [Account]
    private(set) var transactions: [Transaction]
    private(set) var basiq_user: BasiqUser
    private(set) var fir_user: FirebaseAuth.User
    
    init (basiq_user: BasiqUser, name: UsersName) throws {
        guard let fir_auth = FirebaseAuth.Auth.auth().currentUser else { throw AuthError.unAuthenticated() }
        let basiq = try BasiqApi.initialize(basiq_user)
        
        self.fir_user = fir_auth
        self.basiq_user = basiq_user
        self.email = fir_auth.email!
        self.name = name
        self.total_balance = 20000
        self.accounts = []
        self.transactions = []
        
        try basiq.req("users/{id}/accounts", method: .get) { (data: DecodableAccounts?, err) in
            print(err)
            print(data?.data)
        }
    }
    
    init (preview: Bool) throws { throw AuthError.notImplemented() }
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


