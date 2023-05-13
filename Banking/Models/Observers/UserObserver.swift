//
//  Observer.swift
//  Banking
//
//  Created by Toby Clark on 12/5/2023.
//

import Foundation

class UserObserver: NSObject {
    @objc var objectToUpdate: Auth
    var observation: NSKeyValueObservation?
    
    init(object: Auth) {
        objectToUpdate = object
        super.init()
        
        observation = observe(\.objectToUpdate.current, options: [.old, .new]) { object, change in
            print("Auth changed!")
        }
    }
}
