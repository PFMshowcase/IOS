//
//  TransactionsView.swift
//  Banking
//
//  Created by Toby Clark on 23/6/2023.
//

import SwiftUI

struct TransactionsView: View {
    @State var search: String = ""
    @State var sort: TransactionSortingOptions = .dateDescending
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Transactions")
                .font(.banner)
                .hAlignment(.center)
            HStack {
                Text("Search")
            }
            ScrollView(.vertical) {
                TransactionListView(search_input: $search, sorted: $sort)
            }
        }
        .padding(.all, 15)
        .foregroundColor(CustomColour.text.normal)
        .ignoresSafeArea(edges:.bottom)
    }
}
