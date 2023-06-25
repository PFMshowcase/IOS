//
//  InsightsView.swift
//  Banking
//
//  Created by Toby Clark on 22/6/2023.
//

import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        if user.summary != nil {
            VStack {
                VStack {
                    Text("Spending")
                        .font(.h1)
                        .hAlignment()
                    ExpensesGraphView(expenses: user.summary!.monthToDateExpenses, avgExpenses: user.summary!.monthAvgExpenses, maxExpenses: user.summary!.monthAvgExpenses * 1.5)
                }
                .hAlignment()
                VStack {
                    Text("Net Worth")
                        .font(.h1)
                        .hAlignment()
                }
                .hAlignment()
                VStack {
                    Text("Recurring Payments")
                        .font(.h1)
                        .hAlignment()
                }
                .hAlignment()
            }
        } else {
            Text("User summary not yet generated")
        }
    }
}
