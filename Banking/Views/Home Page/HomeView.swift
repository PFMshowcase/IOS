//
//  Home.swift
//  Banking
//
//  Created by Toby Clark on 11/5/2023.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var user: User
        
    var body: some View {
        NavigationView {
            VStack (spacing:30) {
                VStack (spacing:30) {
                    HStack {
                        Text("Hello, " + (user.name.first)).font(.h1)
                    }
                    .hAlignment()
                    
                    VStack {
                        Text("Your available balance is")
                            .font(.small)
                            .foregroundColor(CustomColour.text.medium)
                            .hAlignment()
                        Text(user.total_balance.currency())
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
                        
                        AccountSectionHomeView() 
                            .hAlignment()
                            .padding(.vertical, 10)
                    }
                    .hAlignment(.center)
                    
                    
                    VStack {
                        Text("Insights")
                            .font(.h1)
                            .hAlignment()
                        InsightSectionHomeView()
                            .padding(.top, 25)
                            .padding(.bottom, 10)
                    }
                    .hAlignment(.center)
                    
                    VStack {
                        Text("Recent Transactions")
                            .font(.h1)
                            .hAlignment()
                        
                        TransactionSectionHomeView()
                            .hAlignment()
                            .padding(.vertical, 10)
                        
                    }
                    .hAlignment(.center)
                }
                .scrollBounceBehavior(.basedOnSize)
                
            }
            .padding(.all, 15)
            .bAlignment(.center)
            .ignoresSafeArea(edges:.bottom)
            .background(CustomColour.bg)
        }
    }
}
