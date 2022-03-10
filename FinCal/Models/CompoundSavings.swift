//
//  CompoundSavings.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 10/3/22.
//

import Foundation

class CompoundSavings: Savings, MonthlyPayable {
    var monthlyPayment: Double
    var futureValue: Double
    var principalAmount: Double
    var interest: Double
    var numberOfPayments: Int
    
    init(monthlyPayment:Double, futureValue:Double, principalAmount:Double, interest:Double, numberOfPayments:Int) {
        self.futureValue = futureValue
        self.monthlyPayment = monthlyPayment
        self.principalAmount = principalAmount
        self.interest = interest
        self.numberOfPayments = numberOfPayments
    }
    
    
}
