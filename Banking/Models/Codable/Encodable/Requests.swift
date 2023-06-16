//
//  Requests.swift
//  Banking
//
//  Created by Toby Clark on 13/6/2023.
//

import Foundation


struct EncodableDBUser: Encodable {
    var name: UsersName
    var email: String
}
