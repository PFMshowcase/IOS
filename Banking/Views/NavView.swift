//
//  NavView.swift
//  Banking
//
//  Created by Toby Clark on 22/6/2023.
//

import SwiftUI

struct NavView: View {
    @StateObject var user: User = User.current!
    
    var body: some View {
        switch user.accounts {
        case nil: BasiqConsentView().environmentObject(user)
        default: TabBarView().environmentObject(user)
        }
    }
}


struct TabBarView: View {
    @State var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                TestAcc()
                    .tag(1)
                TestAcc()
                    .tag(2)
                TestAcc()
                    .tag(3)
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
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 20, height: 20)
            if isActive {
                Text(title)
                    .font(.normal)
                    .foregroundColor(isActive ? .black : .gray)
            }
            Spacer()
        }
        .frame(maxWidth: isActive ? .infinity : 60, maxHeight: 60)
        .background(isActive ? CustomColour.secondary.light.opacity(0.4) : .clear)
        .cornerRadius(30)
    }

    enum TabbedItems: Int, CaseIterable{
        case home = 0
        case accounts
        case transactions
        case insights
        
        var title: String{
            switch self {
            case .home:
                return "Home"
            case .accounts:
                return "Accounts"
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
            case .accounts:
                return "building.columns.fill"
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
