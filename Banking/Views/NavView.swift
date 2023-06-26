//
//  NavView.swift
//  Banking
//
//  Created by Toby Clark on 22/6/2023.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                TestAcc()
                    .tag(1)
                HomeView()
                    .tag(0)
                InsightsView()
                    .tag(2)
            }
            
            ZStack {
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 70)
            .background(.regularMaterial)
            .background(CustomColour.secondary.light)
            .cornerRadius(35)
            .padding(.horizontal, 26)
        }
    }
    
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10){
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? CustomColour.text.normal : CustomColour.text.gray)
                .frame(width: 20, height: 20)
            if isActive {
                Text(title)
                    .font(.normal)
                    .foregroundColor(isActive ? CustomColour.text.normal : CustomColour.text.gray)
            }
            Spacer()
        }
        .frame(maxWidth: isActive ? .infinity : 60, maxHeight: 60)
        .background(isActive ? CustomColour.secondary.light.opacity(0.4) : .clear)
        .cornerRadius(30)
    }

    enum TabbedItems: Int, CaseIterable{
        case home = 0
        case transactions
        case insights
        
        var title: String{
            switch self {
            case .home:
                return "Home"
            case .transactions:
                return "Transactions"
            case .insights:
                return "Insights"
            }
        }
        
        var iconName: String{
            switch self {
            case .home:
                return "house"
            case .transactions:
                return "newspaper"
            case .insights:
                return "magnifyingglass"
            }
        }
        
    }
}


struct TestAcc: View {
    var body: some View {
        Text("accoutns")
    }
}
