//
//  Transaction.swift
//  Banking
//
//  Created by Toby Clark on 25/4/2023.
//

import Foundation
import SwiftUI


class Transaction: NSObject {
    var merchant: String
    var merchantDetail: String
    var merchantWebsite: String
    var location: String
    
    var imageLink:String
    
    var vendorImg: Image {
        Image(imageLink)
    }
    var amount: Float
    
    init(merchant: String, merchantDetail: String, merchantWebsite: String, location: String, imageLink: String, amount: Float) {
        self.merchant = merchant
        self.merchantDetail = merchantDetail
        self.merchantWebsite = merchantWebsite
        self.location = location
        self.imageLink = imageLink
        self.amount = amount
    }
}
