//
//  Base.swift
//  Banking
//
//  Created by Toby Clark on 6/6/2023.
//

import Foundation
import SwiftUI

final class SingleDecodableAccount: Decodable {
    let type, id, accountNo, connection, currency, institution, lastUpdated, name, status: String
    let accountHolder, availableFunds, balance, creditLimit: String?
    
    var colour: Color
    var logo: URL?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try values.decode(String.self, forKey: .type)
        self.id = try values.decode(String.self, forKey: .id)
        self.accountNo = try values.decode(String.self, forKey: .accountNo)
        self.connection = try values.decode(String.self, forKey: .connection)
        self.currency = try values.decode(String.self, forKey: .currency)
        self.institution = try values.decode(String.self, forKey: .institution)
        self.lastUpdated = try values.decode(String.self, forKey: .lastUpdated)
        self.name = try values.decode(String.self, forKey: .name)
        self.status = try values.decode(String.self, forKey: .status)
        self.accountHolder = try values.decode(String.self, forKey: .accountHolder)
        self.availableFunds = try values.decode(String.self, forKey: .availableFunds)
        self.balance = try values.decode(String.self, forKey: .balance)
        self.creditLimit = try values.decode(String.self, forKey: .creditLimit)


        self.colour = .primary.base
        self.logo = URL(string:"example.com")
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case accountNo
        case connection
        case currency
        case institution
        case lastUpdated
        case name
        case status
        case accountHolder
        case availableFunds
        case balance
        case creditLimit
    }
}

struct DecodableAccounts: Decodable {
    var type: String
    var data: [SingleDecodableAccount]
}
