//
//  recentTransactionsView.swift
//  Banking
//
//  Created by Toby Clark on 11/6/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TransactionSectionHomeView: View {
    @EnvironmentObject var user: User
        
    var body: some View {
        ForEach(user.transactions ?? []) { (transaction: Transaction) in
            HStack(alignment: .center) {
                WebImage(url: URL(string: "https://enrich-enrichmerchantslogobucket-6or17iuhdvs9.s3-ap-southeast-2.amazonaws.com/7_eleven-thumb.svg"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35, alignment: .center)
                    .padding(.trailing)
                Text(transaction.description)
                    .font(.normal)
                ZStack(alignment: .trailing) {
                    if transaction.direction == "debit" {
                        Text((Double(transaction.amount) ?? 0.0).currency())
                            .font(.normal)
                            .hAlignment(.trailing)
                    } else {
                        ZStack {
                            Text((Double(transaction.amount) ?? 0.0).currency())
                                .font(.normal)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 2.5)
                                .background(.thickMaterial)
                        }
                        .background(CustomColour.green)
                        .cornerRadius(8)
                    }
                }
                .font(.normal)
                .hAlignment(.trailing)
            }
            .padding(.bottom)
        }
    }
}
