//
//  InsightsView.swift
//  Banking
//
//  Created by Toby Clark on 20/6/2023.
//

import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        if user.summary != nil {
//            Set max expenses to 20% more than months avg
            SemiCircleChart(expenses: user.summary!.monthToDateExpenses, avgExpenses: user.summary!.monthAvgExpenses, maxExpenses: user.summary!.monthAvgExpenses * 1.5)
        } else {
            Text("Generating expenses")
        }
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}
