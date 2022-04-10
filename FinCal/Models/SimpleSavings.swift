//
//  SimpleSavings.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 14/3/22.
//

import UIKit

class SimpleSavings: Codable, CustomStringConvertible, Payable {
    init() {
    }

    var futureValue: Double = 0.0
    var principalAmount: Double = 0.0
    var duration: Double = 1.0
    var interest: Double = 0.0
    var compoundsPerYear: Double = 12.0
    var monthlyPayment: Double = 0.0
    
    
    public var description: String { return "\(SimpleSavings.Type.self)(futureValue: \(self.futureValue), principalAmount: \(self.principalAmount), interest: \(self.interest), duration: \(self.duration))" }

    func getFutureValue() -> Double {
        let inner = 1 + interest / compoundsPerYear
        let futureVal = principalAmount * pow(inner, compoundsPerYear * duration)

        return futureVal
    }
    
    func getFutureValue(withMonthlyPayments: Bool) -> Double {
        if !withMonthlyPayments {
            return getFutureValue()
        }
        
        let numerator = pow(1 + (interest / compoundsPerYear), compoundsPerYear * duration) - 1
        let denominator = interest / compoundsPerYear
        let futureVal = monthlyPayment * (numerator/denominator)
        
        let compoundInterest = principalAmount * pow(1 + interest/compoundsPerYear, compoundsPerYear * duration)
        
        return futureVal + compoundInterest
    }
    
    func getRate() -> Double {
        let innerDenominator = futureValue / principalAmount
        let inner = pow(innerDenominator, 1 / (compoundsPerYear * duration)) - 1.0
        let newInterest = compoundsPerYear * inner

        return newInterest
    }
    
    func getRate(withMonthlyPayments: Bool) -> Double {
        if !withMonthlyPayments {
            return getRate()
        }
        
        let innerDenominator = futureValue / principalAmount
        let inner = pow(innerDenominator, 1 / compoundsPerYear * duration) - 1.0
        let newInterest = compoundsPerYear * inner
        
        return newInterest
    }
    
    func getPrincipalAmount() -> Double {
        let denominator = pow(1 + interest/compoundsPerYear, compoundsPerYear + duration)
        let newPrincipalAmount = futureValue/denominator
        
        return newPrincipalAmount
    }
    
    //TODO: Refactor the code below.
    func getPrincipalAmount(withMonthlyPayments:Bool) -> Double {
        if !withMonthlyPayments {
            return getPrincipalAmount()
        }
        
        let interestedCompoundPerYear = interest / compoundsPerYear
        let totalCompounds = compoundsPerYear * duration
        let numerator = monthlyPayment * (pow((1 + interestedCompoundPerYear), totalCompounds) - 1)
        let x = (numerator / interestedCompoundPerYear)
        
        let principalAmount = (futureValue - x ) / pow((1 + interestedCompoundPerYear), totalCompounds)
        
        return principalAmount
    }
    
    func getDuration(withMonthlyPayments: Bool) -> Double {
        if !withMonthlyPayments {
            return getDuration()
        }
        
        let numerator = log(1 + ((interest * futureValue) / monthlyPayment))
        let denominator = log(1 + interest)
        
        return numerator / denominator
    }
    
    func getDuration() -> Double {
        let numerator = log(futureValue / principalAmount)
        let denominator = compoundsPerYear * log(1 + (interest / compoundsPerYear))
        
        return numerator / denominator
    }
}
