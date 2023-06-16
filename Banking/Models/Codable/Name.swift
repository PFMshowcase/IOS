//
//  Name.swift
//  Banking
//
//  Created by Toby Clark on 13/6/2023.
//

import Foundation

typealias UsersName = CodableUsersName

@objc class CodableUsersName: NSObject, Codable, ObservableObject {
    @Published var first: String
    @Published var last: String
    @Published var display: String?
    
    enum CodingKeys: String, CodingKey {
        case first
        case last
        case display
    }
    
    init(first: String, last: String, display: String? = nil) {
        self.first = first
        self.last = last
        self.display = display
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.first = try values.decode(String.self, forKey: .first)
        self.last = try values.decode(String.self, forKey: .last)
        self.display = try values.decodeIfPresent(String.self, forKey: .display)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.first, forKey: .first)
        try container.encode(self.last, forKey: .last)
        try container.encodeIfPresent(self.display, forKey: .display)
    }
    
    var toDict: [String: String?] {
        ["first": self.first, "last": self.last, "display": self.display]
    }
}
