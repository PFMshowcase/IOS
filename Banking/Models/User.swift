//
//  User.swift
//  Banking
//
//  Created by Toby Clark on 6/6/2023.
//

import Foundation
import FirebaseAuth


class User : NSObject, ObservableObject {
    private(set) static var current: User? {
        didSet {
            Auth.auth?.updateUser(current!)
        }
    }
    
    @Published var loaded: Bool = false
    private(set) var email: String
    private(set) var name: UsersName
    private(set) var total_balance: Double
    private(set) var accounts: [SingleDecodableAccount]?
    private(set) var transactions: [Transaction]?
    private(set) var basiq_user: BasiqUser
    private(set) var fir_user: FirebaseAuth.User
    
    init (preview: Bool) throws { throw AuthError.notImplemented() }
    private init(_ basiq_user: BasiqUser,_ name: UsersName) async throws {
        guard User.current == nil else { throw AuthError.alreadyInitialized()}
        guard let fir_auth = FirebaseAuth.Auth.auth().currentUser else { throw AuthError.unAuthenticated() }

        let basiq = try BasiqApi.initialize(basiq_user)
        
        self.fir_user = fir_auth
        self.basiq_user = basiq_user
        self.email = fir_auth.email!
        self.name = name
        self.total_balance = 20000
        self.transactions = nil
        
        let decodedAccounts = try await basiq.req("users/{id}/accounts", method: .get, type: DecodableAccounts.self)
        
        if decodedAccounts.data.count > 0 { self.accounts = decodedAccounts.data }
        else { self.accounts = nil }
    }
    
    static func create (basiq_user: BasiqUser, name: UsersName) async throws { User.current = try await User.init(basiq_user, name) }
    
    func refreshBasiq() async throws {
        let decodedAccounts = try await BasiqApi.api?.req("users/{id}/accounts", method: .get, type: DecodableAccounts.self)
        
        self.accounts = decodedAccounts?.data
    }
}


