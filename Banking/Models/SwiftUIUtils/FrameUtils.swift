//
//  Utils.swift
//  Banking
//
//  Created by Toby Clark on 8/5/2023.
//

import Foundation
import SwiftUI

/* =====================================================
 
    Custom Alignment Frames
 
   ===================================================== */

struct alignmentFrame: ViewModifier {
    var width: CGFloat?
    var height: CGFloat?
    var alignment: Alignment = .leading
    func body(content: Content) -> some View {
        if (width != nil && height != nil) {
            content.frame(maxWidth:.infinity, maxHeight: .infinity, alignment: alignment)
        } else if (width != nil) {
            content.frame(maxWidth:.infinity, alignment: alignment)
        } else if (height != nil) {
            content.frame(maxHeight: .infinity, alignment: alignment)
        }
        
    }
}


extension View {
    func hAlignment(_ align:Alignment = .leading) -> some View {
        modifier(alignmentFrame(width: .infinity, alignment: align))
    }
    func vAlignment(_ align:Alignment = .leading) -> some View {
        modifier(alignmentFrame(height: .infinity, alignment: align))
    }
    func bAlignment(_ align:Alignment = .leading) -> some View {
        modifier(alignmentFrame(width: .infinity, height: .infinity, alignment: align))
    }
}




