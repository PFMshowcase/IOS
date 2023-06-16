//
//  BasiqUtils.swift
//  Banking
//
//  Created by Toby Clark on 3/6/2023.
//

import Foundation
import Alamofire

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
