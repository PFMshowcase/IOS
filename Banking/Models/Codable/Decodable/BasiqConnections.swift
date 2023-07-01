//
//  BasiqConnections.swift
//  Banking
//
//  Created by Toby Clark on 1/7/2023.
//

import Foundation

// NOTE: not all returned data present here, just enough to grab the number of connections
struct DecodableBasiqReqUser: Decodable {
    let connections: DecodableBasiqConnections
}

struct DecodableBasiqConnections: Decodable {
    let count: Int
}
