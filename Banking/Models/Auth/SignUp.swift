//
//  SignUp.swift
//  Banking
//
//  Created by Toby Clark on 13/5/2023.
//

import Foundation


extension Auth {

    
    func createUser (username: String, password: String, name: String) throws -> Void {
        guard self.current == nil else {
            throw AuthError.alreadySignedIn
        }
        
        if self.preview {
            self.current = UserDetails(preview: true)
        }
//        Create a basiq user
        
//        Create user using cloud blocking function, adding their displayName and basiq uuid
        self.current = UserDetails()
    }
}
