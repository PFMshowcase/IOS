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
import FirebaseSharedSwift

class User: ObservableObject {
    private(set) static var current: User? {
        didSet {
            Auth.auth?.updateUser(current!)
        }
    }
    
    private var fir_user: FirebaseAuth.User
    private var db: Firestore
    
    private var decoded_institutions: [String: DecodableInstitution] = [:]
    
    @Published var refreshing: Bool
    @Published var lastRefresh: Date?
    @Published var email: String
    @Published var name: UsersName
    @Published var total_balance: Double
    @Published var transactions: [Transaction]?
    @Published var basiq_user: BasiqUser
    @Published var summary: Summary?

    @Published var accounts: [Account]? {
        didSet {
            var newTransactions: [Transaction] = []
            self.accounts?.forEach() { acc in
                if acc.transactions != nil { newTransactions += acc.transactions! }
            }
            
            newTransactions.sort(by: {first, second in
                if first.postDate <= second.postDate { return true }
                return false
            })
            self.transactions = newTransactions
        }
        
        
    }
    
    init (preview: Bool) throws { throw AuthError.notImplemented() }
    private init(_ user: DBUser) async throws {
        guard User.current == nil else { throw AuthError.alreadyInitialized()}
        guard let fir_auth = FirebaseAuth.Auth.auth().currentUser else { throw AuthError.unAuthenticated() }
        self.db = Firestore.firestore()

        let basiq = try BasiqApi.initialize(user.basiqUser)
        
        self.fir_user = fir_auth
        self.basiq_user = user.basiqUser
        self.email = fir_auth.email!
        self.name = user.name
        self.total_balance = 0
        self.refreshing = user.refreshing
        self.lastRefresh = user.lastRefresh
        
        try await self.getAccounts(basiq)
        try self.addDbListener()
    }
    
    static func create (_ user: DBUser) async throws { User.current = try await User.init(user) }
    
    func refreshBasiq() async throws {
        try await getAccounts(BasiqApi.api!)
        let _ = try await functions.httpsCallable("callable-refreshuser").call()
    }
    
//    TODO: Handle errors
    func addDbListener () throws {
        let userRef = db.collection("users").document(self.fir_user.uid)
        
//        Listen for updates to the users database
        userRef.addSnapshotListener() { documentSnapshot, error in
            Task { @MainActor () in
                guard let doc = documentSnapshot, doc.exists else {
                    print("Error fetching doc")
                    return
                }
                                
                var userData: DBUser?
                print("got user")
                
                do {
                    let decoder = Firestore.Decoder()
                    decoder.dateDecodingStrategy = .timestamp
                    userData = try doc.data(as: DecodableDBUser.self, decoder: decoder)
                } catch {
                    print(error)
                }
                
                self.summary = userData?.summary
                self.refreshing = userData != nil ? userData!.refreshing : false
                self.lastRefresh = userData?.lastRefresh
                self.basiq_user = userData != nil ? userData!.basiqUser : self.basiq_user
                self.name = userData != nil ? userData!.name : self.name
            }
        }
        
//        Listen for transaction updates per account
        self.accounts?.forEach() { acc in
            userRef.collection("transactions").whereField("account", isEqualTo: acc.id).order(by: "postDate", descending: true).limit(to: 10).addSnapshotListener() { querySnapshot, error in
                Task { @MainActor () in
                    do {
                        if let index = self.accounts?.firstIndex(where: { $0.id == acc.id}) {
                            self.accounts![index].transactions = try querySnapshot?.documents.map() { doc -> Transaction in
                                try doc.data(as:Transaction.self)
                            }
                        }
                    } catch {
                        print("could not get transactions for acc \(acc.name)")
                    }
                }
            }
        }
    }

//    TODO: Move to backend since it already performs similar operations
    func getAccounts(_ basiq: BasiqApi) async throws {
        let decoded_acc_data = try await basiq.req("users/{id}/accounts", method: .get, type: DecodableAccounts.self)
        let decoded_accs = decoded_acc_data.data
        var formatted_accs:[Account] = []
        
        for acc in decoded_accs {
            var new_acc = acc
            var institution = decoded_institutions[acc.institutionId]
            
            if institution == nil {
                institution = try await basiq.req(acc.accLinks.institution, method: .get, type: DecodableInstitution.self)
                decoded_institutions[acc.institutionId] = institution
            }
                    
            new_acc.institution = institution!
            new_acc.logo = institution!.logo.links.square
            if new_acc.accClass.product.count > 20 { new_acc.accClass.product = institution!.shortName }
            
            formatted_accs.append(new_acc)
        }
        
        self.total_balance = formatted_accs.reduce(0, {sum, acc in
            if acc.balance != nil { return sum + (Double(acc.balance!) ?? 0) }
            return sum
        }).rounded(2)
        
        if formatted_accs.count > 0 { self.accounts = formatted_accs }
    }
}
