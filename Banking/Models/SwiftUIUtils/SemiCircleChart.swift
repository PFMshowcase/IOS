//
//  SemiCircleChart.swift
//  Banking
//
//  Created by Toby Clark on 16/6/2023.
//

import SwiftUI

struct SemiCircleChart: View {
//    @Binding var current: Double
//    @Binding var max: Double
    var current: Double = 100
    var max: Double = 300
    
    var trim_to: Double { (current/max)/2 }
    
    var body: some View {
        ZStack {
            SemiCircle()
                .stroke(Color.tertiary.dark, style: StrokeStyle(lineWidth: 30, lineCap: .round))
//            SemiCircle()
//                .trim(from: 0.0, to: trim_to)
            Circle()
                .stroke(AngularGradient(gradient: Gradient(colors: [.primary.base, .secondary.light, .tertiary.dark]), center: .center, startAngle: .degrees(0), endAngle: .degrees(15)), style: StrokeStyle(lineWidth: 30, lineCap: .round))
            
//            VStack {
//                Text("250")
//                Text("Feb Spend")
//            }.bAlignment(.center)
        }
        .frame(width: 300, height: 300, alignment: .center)
    }
}

struct SemiCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.size.width, rect.size.height * 2) / 2
        
        path.addArc(center: CGPoint(x: radius, y: radius / 2), radius: radius, startAngle: .zero, endAngle: .degrees(180), clockwise: true)
        return path
    }
}

struct SemiCircleChart_Previews: PreviewProvider {
    
    static var previews: some View {
        SemiCircleChart()
    }
}
