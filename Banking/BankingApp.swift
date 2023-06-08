//
//  BankingApp.swift
//  Banking
//
//  Created by Toby Clark on 12/4/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions
import SDWebImage
import SDWebImageSVGCoder

var functions = Functions.functions(region: "australia-southeast1")

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        Initialize firebase
        FirebaseApp.configure()
        functions.useEmulator(withHost: "localhost", port: 5001)
        
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        
        do {
            try Auth.setup()
            return true
        } catch {
            return false
        }
    }
}

@main
struct BankingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
