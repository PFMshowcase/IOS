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


class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //        Initialize firebase
        FirebaseApp.configure()
        
        do {
            try Auth.initialize(basiq_api_key: "")
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
