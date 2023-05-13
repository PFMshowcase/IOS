//
//  Utils.swift
//  Banking
//
//  Created by Toby Clark on 11/5/2023.
//

import Foundation

/* =====================================================
 
    Auth Protocols and Errors
 
   ===================================================== */


enum AuthError: Error {
    case alreadyInitialized
    case notInitialized
    case alreadySignedIn
}

@objc protocol UserType {
    var email: String { get }
    var name: String { get }
    var uid: String { get }
    var totalBalance: Double { get }
    var accounts: [Account] { get }
    var transactions: [Transaction] { get }
}
