//
//  User.swift
//  Banking
//
//  Created by Toby Clark on 6/6/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    private(set) var accounts: [Account]?
    private(set) var transactions: [Transaction]?
    private(set) var basiq_user: BasiqUser
    private var fir_user: FirebaseAuth.User
    private var db: Firestore
    
    private var decoded_institutions: [String: DecodableInstitution] = [:]
    
    init (preview: Bool) throws { throw AuthError.notImplemented() }
    private init(_ basiq_user: BasiqUser,_ name: UsersName) async throws {
        guard User.current == nil else { throw AuthError.alreadyInitialized()}
        guard let fir_auth = FirebaseAuth.Auth.auth().currentUser else { throw AuthError.unAuthenticated() }
        self.db = Firestore.firestore()

        let basiq = try BasiqApi.initialize(basiq_user)
        
        self.fir_user = fir_auth
        self.basiq_user = basiq_user
        self.email = fir_auth.email!
        self.name = name
        self.total_balance = 20000
        self.transactions = nil
        
        super.init()
        try await getAccounts(basiq)
    }
    
    static func create (basiq_user: BasiqUser, name: UsersName) async throws { User.current = try await User.init(basiq_user, name) }
    
    func refreshBasiq() async throws {
        try await getAccounts(BasiqApi.api!)
        Auth.auth?.updateUser(User.current!)
    }

    func getAccounts(_ basiq: BasiqApi) async throws {
        let decoded_acc_data = try await basiq.req("users/{id}/accounts", method: .get, type: DecodableAccounts.self)
        let decoded_accs = decoded_acc_data.data
        
        for acc in decoded_accs {
            var institution = decoded_institutions[acc.institutionId]
            
            if institution == nil {
                institution = try await basiq.req(acc.accLinks.institution, method: .get, type: DecodableInstitution.self)
                decoded_institutions[acc.institutionId] = institution
            }
                    
            acc.institution = institution!
            acc.logo = institution!.logo.links.square
            if acc.accClass.product.count > 20 { acc.accClass.product = institution!.shortName }
            
            let transaction_query = try await self.db.collection("users").document(self.fir_user.uid).collection("transactions").whereField("account", isEqualTo: acc.id).order(by: "postDate").limit(to: 10).getDocuments()
            
            acc.transactions = try transaction_query.documents.map(){ doc -> Transaction in
                try doc.data(as: Transaction.self)
            }
            
            if acc.transactions != nil && self.transactions != nil {
                self.transactions! += acc.transactions!
            } else if acc.transactions != nil {
                self.transactions = acc.transactions
            }
            
        }
        
        if self.transactions != nil {
            self.transactions?.sort(by: {first, second -> Bool in
                if first.postDate < second.postDate { return true }
                return false
            })
        }
        
        if decoded_accs.count > 0 { self.accounts = decoded_accs }
    }
}

enum GetTransactionType {
    case all
    case account
    case single
}

