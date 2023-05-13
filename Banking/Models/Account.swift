//
//  Account.swift
//  Banking
//
//  Created by Toby Clark on 25/4/2023.
//

import Foundation
import SwiftUI

class Account: NSObject, Identifiable {
    var id: UUID { UUID() }
    
    var provider: String
    var type: String
    var name: String
    var funds: Float
    var balance: Float
    var monthlyIncrease: Float
    var colour: Color
    var logo: URL?
    
    
    var transactions: Array<Transaction> {
        return [Transaction(merchant: "7 Eleven", merchantDetail: "Manly Maths Tutor Wages", merchantWebsite: "website.com", location: "Manly, NSW", imageLink: "linkToImg", amount: -100.08),Transaction(merchant: "Caltex", merchantDetail: "Non Hooli ATM Withdrawal Fee", merchantWebsite: "website.com", location: "Turramurra, NSW", imageLink: "linkToImg", amount: -50.02),Transaction(merchant: "Afterpay", merchantDetail: "AGL RETAIL ENERGY LTD (GAS)", merchantWebsite: "website.com", location: "Epping, NSW", imageLink: "linkToImg", amount: 399.99)]
    }
    
    init(provider: String, type: String, name: String, funds: Float, balance: Float, monthlyIncrease: Float, colour: Color, logo: URL? = nil) {
        self.provider = provider
        self.type = type
        self.name = name
        self.funds = funds
        self.balance = balance
        self.monthlyIncrease = monthlyIncrease
        self.colour = colour
        self.logo = logo
    }
}
