//
//  SemiCircleChart.swift
//  Banking
//
//  Created by Toby Clark on 16/6/2023.
//

import SwiftUI

struct ExpensesGraphView: View {
    var expenses: Double
    var avgExpenses: Double
    var maxExpenses: Double
        
    var body: some View {
        ZStack {
            TypicalSpending(max: maxExpenses, avg: avgExpenses)
            SemiCircle()
                .stroke(CustomColour.tertiary.dark, style: StrokeStyle(lineWidth: 10, lineCap: .round))
            SemiCircle()
                .trim(from: 0.0, to: expenses/maxExpenses)
                .stroke(LinearGradient(stops:[.init(color: CustomColour.green, location: 0), .init(color: CustomColour.orange, location: 0.75), .init(color: CustomColour.red, location: 1)], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 10, lineCap: .round))
            VStack {
                Text(expenses.currency())
                    .foregroundColor(CustomColour.text.normal)
                    .font(.h2)
                Text(Date().monthName() + " Spend")
                    .foregroundColor(CustomColour.text.medium)
                    .font(.small)
            }
        }
        .frame(width: 200, height: 100, alignment: .center)
    }
}

private struct SemiCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.size.width, rect.size.height * 2) / 2
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY * 1.75), radius: radius, startAngle: .degrees(180), endAngle: .zero, clockwise: false)
        return path
    }
}

private struct TypicalSpending: View {
    @State var rect: CGRect = CGRect()
    var max: Double
    var avg: Double
    
    var body: some View {
        ZStack {
            TypicalSpendingLine(avg: avg, max: max)
                .stroke(CustomColour.text.medium, style: StrokeStyle(lineWidth: 4, lineCap: .round))
            VStack() {
                Text("\(avg.currency())")
                    .font(.normal)
                Text("Typical")
                    .font(.small)
            }
            .foregroundColor(CustomColour.text.medium)
            .position(calcPercentagePointOnSemi(avg*1.05, max, rect, distance: 35)[0])
        }.reading(rect: $rect, .local)
    }
}

private struct TypicalSpendingLine: Shape {
    var avg: Double
    var max: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let points = calcPercentagePointOnSemi(avg, max, rect, line: true, distance: 10)
        
        // Create a path from the point to the end point of the line
        path.move(to: points[0])
        path.addLine(to: points[1])
        
        return path
    }
}

private func calcPercentagePointOnSemi(_ val: Double, _ max: Double, _ rect: CGRect, line: Bool = false, distance: Double = 1) -> [CGPoint] {
    let radius = min(rect.size.width, rect.size.height * 2) / 2
    let angle = (val / max) * 180
    
    // Calculate the coordinates of the point based on the angle
    let centerX = rect.midX
    let centerY = rect.midY * 1.75
    let pointX = centerX - radius * cos(angle * .pi / 180) // Convert angle to radians
    let pointY = centerY - radius * sin(angle * .pi / 180) // Subtract sin instead of adding
    
    // Calculate the end point of the line with a distance of 5
    let endX = pointX - distance * cos(angle * .pi / 180) // Extend in the same angle
    let endY = pointY - distance * sin(angle * .pi / 180)
        
    if line {
        return [CGPoint(x: pointX, y: pointY), CGPoint(x: endX, y: endY)]
    } else {
        return [CGPoint(x: endX, y: endY)]

    }
}
