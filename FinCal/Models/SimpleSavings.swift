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

    public var description: String { return "\(SimpleSavings.Type.self)(futureValue: \(futureValue), principalAmount: \(principalAmount), interest: \(interest), duration: \(duration))" }

    var futureValue: Double = 0.0
    var principalAmount: Double = 0.0
    var duration: Int = 1
    var interest: Double = 0.0
    var compoundsPerYear: Int = 12

    func getFutureValue(updateOriginal: Bool = false) -> Double {
        let inner = 1 + (self.interest / Double(self.compoundsPerYear))
        let futureVal = self.principalAmount * pow(inner, Double(self.compoundsPerYear * self.duration))

        if updateOriginal {
            self.futureValue = futureVal
        }

        return futureVal
    }

    func getRate(initialAmount: Double, futureAmount: Double, duration: Int) -> Double {
        var newInterest: Double = 0.0

        let innerDenominator = initialAmount == 0 ? 1 : futureAmount / initialAmount
        let inner = pow(futureAmount / innerDenominator, 1 / Double(self.compoundsPerYear * duration)) - 1
        newInterest = Double(self.compoundsPerYear) * inner

        return newInterest
    }

    func getInterestRateAsPercentage() -> Double {
        return (self.interest * 100).roundTo(decimalPlaces: 2)
    }
}
