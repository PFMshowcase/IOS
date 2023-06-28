//
//  SingleAccountView.swift
//  Banking
//
//  Created by Toby Clark on 23/6/2023.
// 

import SwiftUI

struct SingleAccountView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
    var account: Account
    @State var transaction_search: String = ""
    @State var transaction_sort: TransactionSortingOptions = .dateDescending
    
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Text(Double(account.availableFunds ?? "0.0")?.currency() ?? "")
                    .font(.h1)
                    .hAlignment(.center)
                Text("Available Funds")
                    .font(.small)
                    .foregroundColor(CustomColour.text.medium)
                    .hAlignment(.center)
            }
            .hAlignment(.center)
            .padding(.bottom, 10)
            VStack {
                HStack {
                    Text("Balance")
                        .font(.h2)
                    Text(Double(account.balance ?? "0.0")?.currency() ?? "0")
                        .font(.body)
                        .foregroundColor(CustomColour.text.medium)
                }
                .hAlignment()
                .padding(.bottom, 5)
                HStack {
                    Text("Account Number")
                        .font(.h2)
                    Text(account.accountNo)
                        .font(.body)
                        .foregroundColor(CustomColour.text.medium)
                }
                .hAlignment()
                .padding(.bottom, 5)
                HStack {
                    Text("Account Type")
                        .font(.h2)
                    Text(account.accClass.product)
                        .font(.body)
                        .foregroundColor(CustomColour.text.medium)
                }
                .hAlignment()
                .padding(.bottom, 5)
            }
            VStack {
                HStack() {
                    Text("Transactions")
                        .font(.h1)
                        .hAlignment()
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                .hAlignment()
                
                ScrollView(.vertical) {
                    TransactionListView(search_input: $transaction_search, sorted: $transaction_sort, account: account)
                }
            }
            .bAlignment()
        }
        .padding(.all, 15)
        .padding(.top, 30)
        .foregroundColor(CustomColour.text.normal)
        .ignoresSafeArea(edges:.bottom)
        .background(CustomColour.bg)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.mode.wrappedValue.dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.backward")
                        .bAlignment()
                        .contentShape(Rectangle().size(CGSize(width: 15, height: 15)))
                }
//                .background(CustomColour.orange)
                .padding(.top, 50)
            }
            ToolbarItem(placement: .principal) {
                Text(account.institution?.name ?? "")
                    .font(.banner)
                    .padding(.top, 50)
            }
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 50 && value.translation.width > 100) {
                self.mode.wrappedValue.dismiss()
            }
        }))
    }
}
