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
    private var basiq_user: BasiqUser
    private var basiq_consents: DecodableConsents?
    
    @Published var refreshing: Bool
    @Published var lastRefresh: Date?
    @Published var email: String
    @Published var name: UsersName
    @Published var total_balance: Double
    @Published var transactions: [Transaction]?
    @Published var summary: Summary?
    @Published var connections_needed: Bool = false
    @Published var consent_needed: Bool = false

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
        
        try await checkConnections()
        try await checkConsent()

        try await self.getAccounts(basiq)
        try self.addDbListener()
    }
    
    static func create (_ user: DBUser) async throws { User.current = try await User.init(user) }
    
    func refreshBasiq() async throws {
        try await getAccounts(BasiqApi.api!)
        let _ = try await functions.httpsCallable("callable-refreshuser").call()
        try await checkConnections()
        try await checkConsent()
        
        User.current = self
    }
    
    private func checkConsent() async throws {
        let basiq_res = try await BasiqApi.api!.req("users/{id}/consents", method: .get, type: DecodableConsents.self)
        
        self.consent_needed = basiq_res.size == 0
        self.basiq_consents = basiq_res
    }
    
    private func checkConnections() async throws {
        let basiq_res = try await BasiqApi.api!.req("users/{id}", method: .get, type: DecodableBasiqReqUser.self)
        
        self.connections_needed = basiq_res.connections.count == 0
    }
    
//    MARK: Firestore listener for async updates
//    TODO: Handle errors
    private func addDbListener () throws {
        let userRef = db.collection("users").document(self.fir_user.uid)
        
//        Listen for updates to the users database
        userRef.addSnapshotListener() { documentSnapshot, error in
            Task { @MainActor () in
                guard let doc = documentSnapshot, doc.exists else {
                    print("Error fetching doc")
                    return
                }
                                
                var userData: DBUser?
                
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
                
                User.current = self
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
                    
                    User.current = self
                }
            }
        }
    }

//    TODO: Move to backend since it already performs similar operations
    @MainActor
    private func getAccounts(_ basiq: BasiqApi) async throws {
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
    
//    MARK: Functions for filtering Transactions
    
    func getAllTransactionDates(transactions: [Transaction]? = nil, sortBy: TransactionSortingOptions = .dateDescending) -> [Date] {
        var use_transactions = transactions
        
        if use_transactions == nil { use_transactions = self.transactions }
        
        guard let use_transactions else {
            return []
        }
        
        var dates: [Date] = []
        
        for transaction in use_transactions {
            if !dates.contains(transaction.postDate) {
                dates.append(transaction.postDate)
            }
        }
        
        dates.sort(by: { first, second -> Bool in
            if sortBy == .dateAscending {
                return first < second
            }
            
            return first > second
        })
                
        return dates
    }
    
    func filterTransactions(date: Date, account: Account?, search: String) -> [Transaction] {
//        Check if account is provided otherwise get all transactions
        let unfiltered_transactions: [Transaction]? = account != nil ? account!.transactions : self.transactions
        
//        Unfiltered_transactions may be nil, return an empty array in this case
        guard let unfiltered_transactions = unfiltered_transactions else {
            return []
        }
                
//        Filter the transactions with the provided date
        let date_filtered_transactions = unfiltered_transactions.filter({ $0.postDate == date })
                
//        For some reason .contains returns false when an empty string is checked
        guard search != "" else {
            return date_filtered_transactions
        }
//        Filter the transactions with the provided string
//        TODO: This needs to search more fields than just the description
        let search_filtered_transactions = date_filtered_transactions.filter({ $0.description.contains(search) })
                
        return search_filtered_transactions
    }
}
