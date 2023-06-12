//
//  Institutions.swift
//  Banking
//
//  Created by Toby Clark on 9/6/2023.
//

import Foundation

typealias Institution = DecodableInstitution

class DecodableInstitution: Decodable {
    var type, id, name, shortName, institutionType, country, serviceName, serviceType, status: String
    var logo: DecodableLogoInstitution
}


struct DecodableLogoInstitution: Decodable {
    var type: String
    var links: DecodableLogoLinksInstitution
}

struct DecodableLogoLinksInstitution: Decodable {
    var square, full: URL
}
