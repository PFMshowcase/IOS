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
        LazyVStack {
            ForEach(user.transactions ?? []) { (transaction: Transaction) in
                TransactionListItem(transaction: transaction)
            }
        }
    }
}
