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

extension Date {
    func monthName() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM")
        return df.string(from: self)
    }
}
