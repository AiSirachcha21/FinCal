//
//  Decimal+Extensions.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 11/3/22.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
