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
}
