//
//  Home.swift
//  Banking
//
//  Created by Toby Clark on 11/5/2023.
//

import SwiftUI

struct HomeNavView: View {
    @StateObject var user: User = User.current!
    
    var body: some View {
        switch user.accounts {
        case nil: BasiqConsentView().environmentObject(user)
        default: HomeView().environmentObject(user)
        }
    }
        
}


struct HomeView: View {
    @EnvironmentObject var user: User
        
    var body: some View {
        VStack (spacing:30) {
            VStack (spacing:30) {
                HStack {
                    Text("Hello, " + (user.name.first)).font(.h1)
                }
                .hAlignment()
                
                VStack {
                    Text("Your available balance is")
                        .font(.small)
                        .foregroundColor(.text.medium)
                        .hAlignment()
                    Text("$"+String(user.total_balance))
                        .font(.banner)
                        .hAlignment()
                }
                .hAlignment()
                
            }
            .hAlignment(.center)
            
            ScrollView {
                VStack {
                    Text("Accounts")
                        .font(.h1)
                        .hAlignment()
                    
                    AccountsView() 
                        .hAlignment()
                }
                .hAlignment(.center)
                
                
                VStack {
                    Text("Insights")
                        .font(.h1)
                        .hAlignment()
                }
                .hAlignment(.center)
                
                VStack {
                    Text("Recent Transactions")
                        .font(.h1)
                        .hAlignment()
                    
                    RecentTransactionsView()
                        .hAlignment()
                }
                .hAlignment(.center)
            }
            .scrollBounceBehavior(.basedOnSize)
            
        }
        .padding([.top, .bottom, .leading, .trailing], 15)
        .bAlignment(.center)
        .foregroundColor(.text.normal)
        .background(.background)
        
    }
}
