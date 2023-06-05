//
//  Errors.swift
//  Banking
//
//  Created by Toby Clark on 5/6/2023.
//

import Foundation

// TODO: Figure out how to define new errors without all the duplicated code
class CustomError: Error {
    static func generic (title: String? = nil, message: String? = nil) -> Self { Self.init("generic", title: title, message: message) }
    static func notImplemented (title: String? = nil, message: String? = nil) -> Self { Self.init("notImplemented", title: title, message: message) }
    static func unAuthenticated (title: String? = nil, message: String? = nil) -> Self { Self.init("unAuthenticated", title: title, message: message) }
    static func unhandled (title: String? = nil, message: String? = nil) -> Self { Self.init("unhandled", title: title, message: message) }
    static func alreadyInitialized (title: String? = nil, message: String? = nil) -> Self { Self.init("alreadyInitialized", title: title, message: message) }
    static func notInitialized (title: String? = nil, message: String? = nil) -> Self { Self.init("notInitialized", title: title, message: message) }
        
    let error: String
    let title, message: String?
    var kind: ErrorKind
    
    required init(_ error: String, title: String? = nil, message: String? = nil, kind: ErrorKind = .Base) {
        self.error = error
        self.title = title
        self.message = message
        self.kind = kind
    }
}

struct ErrorKind {
    static let Base = ErrorKind(kind: "Base")
    static let Auth = ErrorKind(kind: "Auth")
    static let Basiq = ErrorKind(kind: "Basiq")
    static let Keychain = ErrorKind(kind: "Keychain")
    
    var kind: String
}

class BasiqError: CustomError {
    static func random (title: String? = nil, message: String? = nil) -> BasiqError { BasiqError("Random", title: title, message: message) }
    
    required init(_ error: String, title: String? = nil, message: String? = nil, kind: ErrorKind = .Basiq) {
        super.init(error, title: title, message: message, kind: kind)
    }
}

class AuthError: CustomError {
    static func alreadySignedIn (title: String? = nil, message: String? = nil) -> AuthError { AuthError("alreadySignedIn", title: title, message: message) }
    static func incorrectPin (title: String? = nil, message: String? = nil) -> AuthError { AuthError("incorrectPin", title: title, message: message) }
    static func biometricAuthFailed (title: String? = nil, message: String? = nil) -> AuthError { AuthError("biometricAuthFailed", title: title, message: message) }
    static func biometricsNotAvailable (title: String? = nil, message: String? = nil) -> AuthError { AuthError("biometricsNotAvailable", title: title, message: message) }
    
    required init(_ error: String, title: String? = nil, message: String? = nil, kind: ErrorKind = .Auth) {
        super.init(error, title: title, message: message, kind: kind)
    }
}

class KeychainError: CustomError {
    static func unexpectedValues (title: String? = nil, message: String? = nil) -> KeychainError { KeychainError("unexpectedValues", title: title, message: message) }
    static func uuidNeededToUpdate (title: String? = nil, message: String? = nil) -> KeychainError { KeychainError("uuidNeededToUpdate", title: title, message: message) }
    static func accountOrDataNeeded (title: String? = nil, message: String? = nil) -> KeychainError { KeychainError("accountOrDataNeeded", title: title, message: message) }

    
    required init(_ error: String, title: String? = nil, message: String? = nil, kind: ErrorKind = .Keychain) {
        super.init(error, title: title, message: message, kind: kind)
    }
}
