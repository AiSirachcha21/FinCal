import UIKit
import Darwin

var interestRate: Double = 0.10
var principalAmount: Double = 1000.0
var numberOfPayments: Int = 12 // In Months
var timeInvested: Int = 1 // In years

// Simple Savings

func calculateFutureValue(principalAmount: Double, interestRate: Double, paymentCount: Int, timeInvestedFor: Int) -> Double {
    let inner = 1 + (interestRate / Double(paymentCount))
    let futureVal = principalAmount * pow(inner, Double(paymentCount * timeInvestedFor))

    return Double(round(futureVal * 100) / 100)
}

func calculateRate(paymentCount: Int, futureValue: Double, principalAmount: Double, timeInvestedFor: Int) -> Double {
    let inner = pow(futureValue/principalAmount, 1/Double(paymentCount*timeInvestedFor)) - 1
    let rate = Double(paymentCount) * inner

    return Double(round(rate * 100) / 100)
}

func calculatePrincipalAmount(futureValue: Double, interestRate: Double, paymentCount: Int, timeInvestedFor: Int) -> Double {
    let denominator = pow(Double(1 + (interestRate/Double(paymentCount))), Double(paymentCount * timeInvestedFor))
    let principalAmount = futureValue / denominator

    return Double(round(principalAmount * 100) / 100)
}

func getMortgagePayment() -> Double {
    let duration = 21
    let ir = 0.05
    
    let monthlyInterest = Double(ir/12)
    let top = 2000 * monthlyInterest * pow(1+monthlyInterest, Double(duration))
    let bot = pow(1 + monthlyInterest,Double(duration)) - 1
    
    return top / bot
}

func getMortgageDuration() -> Double {
    let ir:Double = 0.05 / 12
    let payment:Double = 100.0
    let loanAmount: Double = 2000.0
    
    let numerator = log(1 - (ir * loanAmount / payment))
    let denominator = log(1 + ir)
    
    return abs(numerator / denominator)
}

getMortgagePayment()
getMortgageDuration()
