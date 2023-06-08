//
//  SwiftUIView.swift
//  Banking
//

//  Created by Toby Clark on 25/4/2023.


import SwiftUI
import SDWebImageSwiftUI

struct AccountsView: View {
    var user: User
    
    var body: some View {
        ScrollView {
            HStack{
                ForEach(user.accounts ?? []) {account in
                    AccountWidget(account: account)
                }
            }
            
        }
    }
}

struct AccountWidget: View {
    
    var account: SingleDecodableAccount
    
    var body: some View {
//        VStack to create the background and a frame to contain the widget
        VStack() {
//            Second VStack for internal padding
            VStack(alignment:.leading) {
//                Horizontal Stack with bank name and logo
                HStack() {
                    WebImage(url: account.logo)
                    Text(account.institution)
                        .font(.normal)
                        .frame(maxWidth: .infinity, alignment:.trailing)
                }
                .bAlignment(.top)
                
//                Account Type
                Text(account.type)
                    .font(.normal)
//                Available Funds
                Spacer()
                Text("$"+String(account.balance ?? "_0"))
                    .font(.h2)
                    .vAlignment(.bottom)
                
//                Footer (percentage up last 30 days)
                HStack {
                    Text("up")
                    Text("$200 last 30 days")
                }
                .font(.small)
                .frame(alignment: .bottom)
                
            }
            .padding([.leading, .trailing, .bottom, .top], 15)
            
        }
        .frame(width: 150, height: 150)
        .background(account.colour)
        .foregroundColor(.white).cornerRadius(16)
    }
}




//struct AccountsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountsView(user).previewLayout(.sizeThatFits)
//    }
//}
