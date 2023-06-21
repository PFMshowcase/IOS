//
//  UserUtils.swift
//  Banking
//
//  Created by Toby Clark on 16/6/2023.
//

import Foundation


extension Double {
    func rounded(_ digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
    
    func currency(_ digits: Int = 2) -> String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = digits
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "undefined"
    }
}
