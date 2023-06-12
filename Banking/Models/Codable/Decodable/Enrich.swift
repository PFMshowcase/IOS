//
//  Enrich.swift
//  Banking
//
//  Created by Toby Clark on 10/6/2023.
//

import Foundation


struct DecodableEnrich: Decodable {
    var cleanDescription: String
    var merchant: DecodableMerchant
}

struct DecodableMerchant: Decodable {
    var id, businessName, ABN, logoMaster, logoThumb, website: String
}
