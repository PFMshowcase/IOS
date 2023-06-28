//
//  TextFieldUtils.swift
//  Banking
//
//  Created by Toby Clark on 6/6/2023.
//

import Foundation
import SwiftUI

struct TextFieldStyles: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 50)
            .padding(.horizontal, 5)
            .textFieldStyle(PlainTextFieldStyle())
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(CustomColour.primary.light))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

struct ButtonStyles: ViewModifier {
    var colour: Color
    
    func body(content: Content) -> some View {
        content
            .font(.h2)
            .buttonStyle(.borderedProminent)
            .tint(self.colour)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

extension View {
    func textFieldStyles() -> some View {
        modifier(TextFieldStyles())
    }
    
    func buttonStyles(_ colour: Color = CustomColour.primary.base) -> some View {
        modifier(ButtonStyles(colour: colour))
    }
    
    func reading(rect binding: Binding<CGRect>, _ space: CoordinateSpace = .global) -> some View {
        self.background(rectReader(binding, space))
    }
}

func rectReader(_ binding: Binding<CGRect>, _ space: CoordinateSpace = .global) -> some View {
    GeometryReader { (geometry) -> Color in
        let rect = geometry.frame(in: space)
        DispatchQueue.main.async {
            binding.wrappedValue = rect
        }
        return .clear
    }
}

private var ordinalFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter
}()

extension Date {
    func monthName() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM")
        return df.string(from: self)
    }
    
    func monthDay() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd")
        let num = Int(df.string(from: self))
        
        guard let num else { return df.string(from: self) }
        
        return ordinalFormatter.string(from: num as NSNumber) ?? df.string(from: self)
    }
    
    func formatDay() -> String {
//        Check how long ago the date is from now
        let calendar = Calendar.current
        let df = DateFormatter()
        
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date.now), to: calendar.startOfDay(for: self))
        
//        If it is today or yesterday, use a relative day (eg: Yesterday)
        if components.day != nil && components.day! > -2 {
            let relative_df = RelativeDateTimeFormatter()
            relative_df.dateTimeStyle = .named
            relative_df.unitsStyle = .spellOut

            return relative_df.localizedString(from: components).capitalized
//        If it is within the last week then get the relative day (eg: Wednesday)
        } else if components.day != nil && components.day! > -7 {
            df.setLocalizedDateFormatFromTemplate("EEEE")
            return df.string(from: self)
        }
        
//        Else return the date formatted as MMMM dd (eg: January 1st)
        return "\(monthName()) \(monthDay())"
    }
}

