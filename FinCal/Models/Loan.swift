//
//  Loan.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 3/4/22.
//

import Foundation

class Loan : Codable, CustomStringConvertible, Payable {
    var principalAmount: Double = 0.0
    var interest: Double = 0.0
    var monthlyPayment: Double = 0.0
    var duration: Double = 1.0
    private let futureValue: Double = 0.0
    
    public var description: String {
        return "\(Loan.Type.self)(principalAmount: \(self.principalAmount), interest: \(self.interest), monthlyPayment: \(self.monthlyPayment)), duration: \(self.duration))"
    }
    
    func getMortgagePayment() -> Double{
        let monthlyInterest = Double(interest / 12)
        let top = principalAmount * monthlyInterest * pow(1 + monthlyInterest, duration)
        let bot = pow(1 + monthlyInterest, Double(duration)) - 1
        
        return top / bot
    }
    
    func getMortgageDuration() -> Double {
        let interestPerMonth = interest / 12
        let D = monthlyPayment / interestPerMonth
        
        return  (log(D / (D - principalAmount)) / log(1 + interestPerMonth)) / 12
    }
}
