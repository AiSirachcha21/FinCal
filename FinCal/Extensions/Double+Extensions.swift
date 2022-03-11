//
//  Double+Extensions.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 11/3/22.
//

import Foundation
import Darwin

extension Double {
    func roundTo(decimalPlaces:Int = 0) -> Double {
        let multiplier = pow(10 , decimalPlaces).doubleValue
        let currentValue = self
        
        let roundedValue = Darwin.round(currentValue * multiplier) / multiplier
        return roundedValue
    }
}
