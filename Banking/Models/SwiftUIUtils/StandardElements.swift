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
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary.light))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

struct ButtonStyles: ViewModifier {
    var colour: Color
    
    func body(content: Content) -> some View {
        content
            .font(.h2)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(colour)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

extension View {
    func textFieldStyles() -> some View {
        modifier(TextFieldStyles())
    }
    
    func buttonStyles(_ colour: Color = .primary.base) -> some View {
        modifier(ButtonStyles(colour: colour))
    }
}
