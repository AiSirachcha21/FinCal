//
//  SimpleSavingsViewModel.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 24/3/22.
//

import UIKit

class SimpleSavingsViewModel {
    var savings = SimpleSavings()
    
    func calculateFutureValue(withMonthlyPayments hasMonthlyPayments: Bool) -> Double {
        return savings.getFutureValue(withMonthlyPayments: hasMonthlyPayments)
    }
    
    func calculateInterest(withMonthlyPayments hasMonthlyPayments: Bool) -> Double {
        return savings.getRate(withMonthlyPayments: hasMonthlyPayments)
    }
    
    func updateModelState(_ field: UITextField) {
        switch field.tag {
            case TextFieldID.futureValue.rawValue:
                savings.futureValue = Double(field.text!) ?? 0.0
                break
                
            case TextFieldID.principalAmount.rawValue:
                savings.principalAmount = Double(field.text!) ?? 0.0
                break
                
            case TextFieldID.interest.rawValue:
                let interest = Double(field.text!) ?? 0.0
                savings.interest = interest / 100.0
                break
                
            case TextFieldID.duration.rawValue:
                savings.duration = Int(field.text!) ?? 0
                break
                
            case TextFieldID.monthlyPayments.rawValue:
                savings.monthlyPayment = Double(field.text!) ?? 0.0
                break
                
            default:
                break
        }
    }
}
