//
//  Transactions.swift
//  Banking
//
//  Created by Toby Clark on 10/6/2023.
//

import Foundation

typealias Transaction = DecodableTransaction

struct DecodableTransaction: Decodable, Identifiable {
    var id, account, amount, balance, transactionClass, connection, description, direction, institution, status, transactionDate: String
    var transactionSubClass: DecodableSubClassTransaction?
    var links: DecodableLinkTransaction
    var enrich: DecodableEnrich?
    var postDate: Date
        
    enum CodingKeys: String, CodingKey {
        case id
        case account
        case amount
        case balance
        case transactionClass = "class"
        case connection
        case description
        case direction
        case institution
        case postDate
        case status
        case transactionSubClass = "subClass"
        case transactionDate
        case links
        case enrich
    }
}

struct DecodableSubClassTransaction: Decodable { var code, title: String? }

struct DecodableLinkTransaction: Decodable {
    var account, institution, transaction: URL
    
    enum CodingKeys: String, CodingKey {
        case account
        case transaction = "self"
        case institution
    }
}
