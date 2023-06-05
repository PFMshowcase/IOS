//
//  BasiqUtils.swift
//  Banking
//
//  Created by Toby Clark on 3/6/2023.
//

import Foundation
import FirebaseFirestore
import Alamofire


@objc class BasiqUser: NSObject {
    var id, token: String
    var expiry: Date
    
    init?(dict: [String: Any]) {
        guard let reqId = dict["basiq-uuid"] as? String,
              let reqToken = dict["basiq-token"] as? String,
              let reqExpiry = dict["basiq-token-expiry"] as? Int else { return nil }
        
        self.id = reqId
        self.token = reqToken
        self.expiry = Date(timeIntervalSince1970: Double(reqExpiry))
    }
}

typealias apiCompletionHandler<T> = (T?, AFError?) -> Void

struct Test: Decodable {
    var str: String
}

enum ResponseTypes {
    case string
    case data
    case decodable
    case none
}

// Workaround so I can use different overrides for each method
// TODO: Make this cleaner
enum BasiqHTTPMethods {
    enum post {
        case post
    }
    enum get {
        case get
    }
    enum delete {
        case delete
    }
}
