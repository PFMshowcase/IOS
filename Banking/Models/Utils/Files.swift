//
//  Files.swift
//  Banking
//
//  Created by Toby Clark on 30/6/2023.
//

import Foundation


func getTextFile(_ filename: String, filetype: String = "js") -> String {
    if let filepath = Bundle.main.path(forResource: filename, ofType: "js") {
        do {
            return try String(contentsOfFile: filepath)
        } catch {
            return ""
        }
    } else {
        return ""
    }
}
