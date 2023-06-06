//
//  Home.swift
//  Banking
//
//  Created by Toby Clark on 11/5/2023.
//

import SwiftUI

struct Home: View {
    var user: UserType
    
    init(_ user: UserType) {
        self.user = user
    }
    
    var body: some View {
        ScrollView {
            VStack (spacing:30) {
//                Button("test") {
//                    do{
//                        let basiq = BasiqApi.api!
//                        print(basiq.basiq_data.id)
//                        print(basiq.basiq_data.token)
//                        try basiq.req("users/\(basiq.basiq_data.id)", method: .get) { (data: Data?, err) in
//                            print(err)
//                            print("basiq request")
//                            print(data)
//                        }
//                    }
//                    catch {
//                        print(error)
//                    }
//                }
                VStack (spacing:30) {
                    HStack {
                        Text("Hello, " + user.name.fName).font(.h1)
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
                }
                .hAlignment(.center)
                
            }
            .padding([.top, .bottom, .leading, .trailing], 15)
            .bAlignment(.center)
            .foregroundColor(.text.normal)
        }
        .background(.background)
        .scrollBounceBehavior(.basedOnSize)
    }
}
