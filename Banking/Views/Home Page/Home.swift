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
        
        functions.httpsCallable("createuser").call(["name": "test"]) { result, err in
            print("called")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack (spacing:30) {
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
                        Text("$"+String(user.totalBalance))
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

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}
