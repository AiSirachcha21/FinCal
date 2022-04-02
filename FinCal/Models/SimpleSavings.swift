//
//  SimpleSavings.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 14/3/22.
//

import Foundation
import UIKit

class SimpleSavings: CustomStringConvertible {
    init() {
    }

    var futureValue: Double = 0.0
    var principalAmount: Double = 0.0
    var duration: Int = 1
    var interest: Double = 0.0
    var compoundsPerYear: Int = 12
    
    
    public var description: String { return "\(SimpleSavings.Type.self)(futureValue: \(self.futureValue), principalAmount: \(self.principalAmount), interest: \(self.interest), duration: \(self.duration))" }

    func getFutureValue(updateOriginal: Bool = false) -> Double {
        let inner = 1 + Double(self.interest / 100) / Double(self.compoundsPerYear)
        let futureVal = principalAmount * pow(inner, Double(compoundsPerYear) * Double(duration))

        if updateOriginal {
            self.futureValue = futureVal
        }

        return futureVal
    }

    func getRate() -> Double {
        let innerDenominator = futureValue / principalAmount
        let inner = pow(innerDenominator, 1 / Double(compoundsPerYear * duration)) - 1.0
        let newInterest = Double(compoundsPerYear) * inner

        return newInterest
    }
    
    func getPrincipalAmount() -> Double {
        let numerator = futureValue
        let denominator = pow(1 + interest/Double(compoundsPerYear), Double(compoundsPerYear) + Double(duration))
        let newPrincipalAmount = numerator/denominator
        
        return newPrincipalAmount
    }

    func getInterestRateAsPercentage() -> Double {
        return (self.interest * 100).roundTo(decimalPlaces: 2)
    }
}
