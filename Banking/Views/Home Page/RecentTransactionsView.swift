//
//  recentTransactionsView.swift
//  Banking
//
//  Created by Toby Clark on 11/6/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecentTransactionsView: View {
    @EnvironmentObject var user: User
        
    var body: some View {
        ScrollView(.vertical) {
            ForEach(user.transactions ?? []) { transaction in
                HStack(alignment: .center) {
                    WebImage(url: URL(string: "https://enrich-enrichmerchantslogobucket-6or17iuhdvs9.s3-ap-southeast-2.amazonaws.com/7_eleven-thumb.svg"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35, alignment: .center)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Merchant")
                            .font(.normal)
                        Text(transaction.transactionClass)
                            .font(.small)
                            .foregroundColor(Color.text.medium)
                    }
                    Text(transaction.amount)
                        .font(.normal)
                        .hAlignment(.trailing)
                }
                .padding(.bottom)
            }
        }
    }
}
