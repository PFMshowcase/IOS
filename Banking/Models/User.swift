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
        
        self.accounts = try await getAccounts(basiq)
    }
    
    static func create (basiq_user: BasiqUser, name: UsersName) async throws { User.current = try await User.init(basiq_user, name) }
    
    func refreshBasiq() async throws {
        self.accounts = try await getAccounts(BasiqApi.api!)
        Auth.auth?.updateUser(User.current!)
    }
    
    
}

fileprivate func getAccounts(_ basiq: BasiqApi) async throws -> [SingleDecodableAccount]? {
    let decoded_acc_data = try await basiq.req("users/{id}/accounts", method: .get, type: DecodableAccounts.self)
    let decoded_accs = decoded_acc_data.data
    
    for acc in decoded_accs {
        let institution = try await basiq.req(acc.accLinks.institution, method: .get, type: DecodableInstitution.self)
        acc.institution = institution
        acc.logo = URL(string:institution.logo.links.square)
        if acc.accClass.product.count > 20 { acc.accClass.product = institution.shortName }
    }
    
    if decoded_accs.count > 0 { return decoded_accs }
    else { return nil }
}

