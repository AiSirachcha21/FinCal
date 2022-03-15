//
//  SimpleSavings.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 14/3/22.
//

import Foundation

class SimpleSavings: Savings {

    init(futureValue: Double? = nil, principalAmount: Double, annualInterestRate: Double = 0.0, paymentCount: Int = 12, duration: Int = 1) {
        self.futureValue = futureValue
        self.principalAmount = principalAmount
        self.interest = annualInterestRate
        self.numberOfPayments = paymentCount
        self.duration = duration
    }

    var futureValue: Double?
    var principalAmount: Double
    var duration: Int
    var interest: Double
    var numberOfPayments: Int

    func getFutureValue(updateOriginal: Bool = false) -> Double {
        let inner = 1 + (self.interest / Double(self.numberOfPayments))
        let futureVal = self.principalAmount * pow(inner, Double(self.numberOfPayments * self.duration))

        if updateOriginal {
            self.futureValue = futureVal
        }

        return futureVal
    }

    func getRate(updateOriginal: Bool = false) -> Double {
        var newInterest: Double = 0.0

        if let existingFutureValue = self.futureValue {
            let innerDenominator = self.principalAmount > 0 ? existingFutureValue/self.principalAmount : 0
            let inner = pow(existingFutureValue/innerDenominator, 1/Double(self.numberOfPayments*self.duration)) - 1
            newInterest = Double(self.numberOfPayments) * inner

            if updateOriginal {
                self.interest = newInterest
            }
        }
        return newInterest
    }

    func getInterestRateAsPercentage() -> Double {
        return (self.interest * 100).roundTo(decimalPlaces: 2)
    }
}
