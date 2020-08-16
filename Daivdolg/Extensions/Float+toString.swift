//
//  Float+toString.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 16.08.2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation

extension Float {
    var floatAsCurrency: String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        return formatter.string(from: self as NSNumber)!
    }
}
