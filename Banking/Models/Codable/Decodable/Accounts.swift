//
//  Base.swift
//  Banking
//
//  Created by Toby Clark on 6/6/2023.
//

import Foundation
import SwiftUI

typealias Account = SingleDecodableAccount

struct SingleDecodableAccount: Decodable, Identifiable {
    let type, id, accountNo, connection, currency, lastUpdated, name, status, institutionId: String
    let accountHolder, availableFunds, balance, creditLimit: String?
    var accClass: DecodableClassAccounts
    let accLinks: DecodableLinkAccounts
    var institution: DecodableInstitution?
    var transactions: [Transaction]?
    
    var colour: (Color, Color)
    var logo: URL?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try values.decode(String.self, forKey: .type)
        self.id = try values.decode(String.self, forKey: .id)
        self.accountNo = try values.decode(String.self, forKey: .accountNo)
        self.connection = try values.decode(String.self, forKey: .connection)
        self.currency = try values.decode(String.self, forKey: .currency)
        self.lastUpdated = try values.decode(String.self, forKey: .lastUpdated)
        self.name = try values.decode(String.self, forKey: .name)
        self.status = try values.decode(String.self, forKey: .status)
        self.accountHolder = try values.decode(String.self, forKey: .accountHolder)
        self.availableFunds = try values.decode(String.self, forKey: .availableFunds)
        self.balance = try values.decode(String.self, forKey: .balance)
        self.creditLimit = try values.decode(String.self, forKey: .creditLimit)
        self.accClass = try values.decode(DecodableClassAccounts.self, forKey: .accClass)
        self.accLinks = try values.decode(DecodableLinkAccounts.self, forKey: .accLinks)
        self.institutionId = try values.decode(String.self, forKey: .institutionId)

        let colour_options: [(Color, Color)] = [(CustomColour.secondary.light, CustomColour.text.black), (CustomColour.primary.dark, CustomColour.text.white), (CustomColour.tertiary.base, CustomColour.text.white)]
        self.colour = colour_options.randomElement() ?? (CustomColour.primary.base, CustomColour.text.black)
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case accountNo
        case connection
        case currency
        case lastUpdated
        case name
        case status
        case accountHolder
        case availableFunds
        case balance
        case institutionId = "institution"
        case creditLimit
        case accClass = "class"
        case accLinks = "links"
    }
}

struct DecodableClassAccounts: Decodable {
    var type: String
    var product: String
}

struct DecodableLinkAccounts: Decodable {
    var institution: String
    var transactions: String
    var account: String
    
    enum CodingKeys: String, CodingKey {
        case institution
        case transactions
        case account = "self"
    }
}

struct DecodableAccounts: Decodable {
    var type: String
    var data: [SingleDecodableAccount]
}
