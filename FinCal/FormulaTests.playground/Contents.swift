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
