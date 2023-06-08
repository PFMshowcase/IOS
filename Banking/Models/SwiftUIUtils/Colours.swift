//
//  Colours.swift
//  Banking
//
//  Created by Toby Clark on 12/5/2023.
//

import Foundation
import SwiftUI

/* =====================================================
 
    Colours
 
   ===================================================== */


extension Color {
//    Background
    static let bg = Color("bg")
    
//    UX labels (toasts, success, etc)
    static let green = Color("green")
    static let orange = Color("orange")
    static let red = Color("red")
    static let yellow = Color("yellow")
    
//    Text Colours
    struct text {
        static let black = Color("text-black")
        static let gray = Color("text-gray")
        static let medium = Color("text-medium")
        static let normal = Color("text-normal")
        static let white = Color("text-white")
    }
    
//    UI Colours
    struct primary {
        static let base = Color("p")
        static let light = Color("p-l")
        static let dark = Color("p-d")
    }
    
    struct secondary {
        static let base = Color("s")
        static let light = Color("s-l")
        static let dark = Color("s-d")
    }
    
    struct tertiary {
        static let base = Color("t")
        static let light = Color("t-l")
        static let dark = Color("t-d")
    }
}
