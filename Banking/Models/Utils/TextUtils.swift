//
//  TextUtils.swift
//  Banking
//
//  Created by Toby Clark on 12/5/2023.
//

import Foundation
import SwiftUI

/* =====================================================
 
    Font extensions
 
   ===================================================== */


//Font types
enum Cabin: String {
    case semiBold = "Cabin-semiBoldItalic"
    case semiBoldItalic = "Cabin-semiBold"
    case regular = "Cabin-Regular"
    case mediumItalic = "Cabin-MediumItalic"
    case medium = "Cabin-Medium"
    case italic = "Cabin-Italic"
    case boldItalic = "Cabin-BoldItalic"
    case bold = "Cabin-Bold"
}

extension Font.TextStyle {
    
//    This should *only* be used for the custom Font extensions
    var size: CGFloat {
        switch self {
        case .title: return 40
        case .title2: return 28
        case .title3: return 20
        case .body: return 14
        case .caption: return 12
        case .caption2: return 10
        
//        Disregard other font types and unknown (return body)
        case .largeTitle, .headline, .subheadline, .callout, .footnote: return 14
        @unknown default: return 14
        }
    }
}

extension Font {
    static func custom(_ font: Cabin, relativeTo style: Font.TextStyle) -> Font {
        custom(font.rawValue, size: style.size, relativeTo: style)
    }
    
//    Font names align with names inc in Figma UI
//    Title has been renamed to 'banner' as it is already set on Font
    static let banner = custom(Cabin.regular, relativeTo: .title)
    static let h1 = custom(Cabin.bold, relativeTo: .title2)
    static let h2 = custom(Cabin.medium, relativeTo: .title3)
    static let normal = custom(Cabin.regular, relativeTo: .body)
    static let small = custom(Cabin.regular, relativeTo: .caption)
    static let extraSmall = custom(Cabin.regular, relativeTo: .caption2)
}
