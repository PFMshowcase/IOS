//
//  User.swift
//  Banking
//
//  Created by Toby Clark on 13/6/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseSharedSwift

typealias DBUser = DecodableDBUser
typealias BasiqUser = DecodableBasiqUser
typealias Summary = DecodableSummary

struct DecodableDBUser: Decodable {
    var name: UsersName
    var basiqUser: DecodableBasiqUser
    var basiqTransactions: DecodableBasiqTransactions?
    var summary: DecodableSummary?
    var refreshing: Bool
    var lastRefresh: Date?
    
    enum CodingKeys: String, CodingKey {
        case name
        case basiqUser = "basiq_user"
        case basiqTransactions = "basiq_transactions"
        case summary
        case refreshing
        case lastRefresh = "last_refresh"
    }
}

struct DecodableBasiqUser: Decodable {
    var id, token: String
    var expiry: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case token
        case expiry = "token_expiry"
    }
}

struct DecodableBasiqTransactions: Decodable {
    var first, latest: Date
    
    enum CodingKeys: String, CodingKey {
        case first = "first_transaction"
        case latest = "latest_transaction"
    }
}

struct DecodableSummary: Decodable {
    var monthToDateIncome, monthToDateExpenses, monthToDateSavings, monthAvgExpenses: Double
    var monthAvgIncome, monthAvgSavings: Double?
    
    enum CodingKeys: String, CodingKey {
        case monthToDateIncome = "month_to_date_income"
        case monthToDateExpenses = "month_to_date_expenses"
        case monthToDateSavings = "month_to_date_savings"
        case monthAvgIncome = "month_avg_income"
        case monthAvgExpenses = "month_avg_expenses"
        case monthAvgSavings = "month_avg_savings"
    }
}
