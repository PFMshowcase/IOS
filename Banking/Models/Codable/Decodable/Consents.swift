//
//  Consents.swift
//  Banking
//
//  Created by Toby Clark on 1/7/2023.
//

import Foundation

struct DecodableConsents: Codable {
    let type: String
    let size: Int
    let data: [DecodableConsentElement]
}

// MARK: - WelcomeElement
struct DecodableConsentElement: Codable {
    let type, id: String
//    let created, updated, expiryDate: Date
//    let status: String
//    let purpose: Purpose
//    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let retainData: Bool
    let permissions: [Permission]
}

// MARK: - Permission
struct Permission: Codable {
    let scope: String
    let permissionRequired: Bool
    let entity: String
    let information: Information
    let purpose: Primary
    
    enum CodingKeys: String, CodingKey {
        case scope
        case permissionRequired = "required"
        case entity, information, purpose
    }
}

// MARK: - Information
struct Information: Codable {
    let name, description: String
    let attributeList: [String]
}

// MARK: - Primary
struct Primary: Codable {
    let title, description: String
}

// MARK: - Purpose
struct Purpose: Codable {
    let primary: Primary
}
