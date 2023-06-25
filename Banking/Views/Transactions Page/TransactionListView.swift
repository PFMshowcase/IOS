//
//  TransactionListView.swift
//  Banking
//
//  Created by Toby Clark on 23/6/2023.
//

import SwiftUI

struct TransactionListView: View {
    @Binding var search_input: String
    @Binding var sorted: TransactionSortingOptions
    @EnvironmentObject var user: User
    
    var account: Account? = nil
    
    
    func transactions(_ date: Date) -> [Transaction] {
        user.filterTransactions(date: date, account: account, search: search_input)
    }
    
    var body: some View {
        LazyVStack {
            ForEach(user.getAllTransactionDates(transactions: account?.transactions), id: \.self) { date in
                Section(header: Text(date.formatted()).font(.h2).hAlignment()) {
                    let transactionList = transactions(date)
                    ForEach(Array(zip(transactionList.indices, transactionList)), id: \.0) { index, transaction in
                        VStack(spacing: 0) {
                            TransactionListItem(transaction: transaction)
                            
                            if (index + 1 < transactionList.count) { Divider() }
                        }
                    }
                }
            }
        }
        .padding(.bottom, 100)
    }
}

enum TransactionSortingOptions {
    case costDescending
    case costAscending
    case dateDescending
    case dateAscending
}
