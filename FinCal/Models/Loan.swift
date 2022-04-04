//
//  Loan.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 3/4/22.
//

import Foundation

class Loan : Payable {
    var principalAmount: Double = 0.0
    var interest: Double = 0.0
    var monthlyPayment: Double = 0.0
    var duration: Int = 1
    private let futureValue: Double = 0.0
    
    func getMortgagePayment() -> Double{
        let monthlyInterest = Double(interest / 12)
        let top = principalAmount * monthlyInterest * pow(1 + monthlyInterest, Double(duration))
        let bot = pow(1 + monthlyInterest, Double(duration)) - 1
        
        return top / bot
    }
    
    func getMortgageDuration() -> Double {
        let monthlyInterest = interest / 12
        let numerator = log(1 - monthlyInterest * principalAmount / monthlyPayment)
        let denominator = log(1 + monthlyInterest)
        
        return abs(numerator / denominator)
    }
}
