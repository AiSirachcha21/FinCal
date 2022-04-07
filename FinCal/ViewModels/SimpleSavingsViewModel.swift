//
//  SimpleSavingsViewModel.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 24/3/22.
//

import UIKit

class SimpleSavingsViewModel : StatefulViewModel<SimpleSavings> {
    func calculateFutureValue(withMonthlyPayments hasMonthlyPayments: Bool) -> Double {
        return state.getFutureValue(withMonthlyPayments: hasMonthlyPayments)
    }
    
    func calculateInterest(withMonthlyPayments hasMonthlyPayments: Bool) -> Double {
        return state.getRate(withMonthlyPayments: hasMonthlyPayments)
    }
    
    func updateModelStateUsing(_ field: UITextField) {
        switch field.tag {
            case TextFieldID.futureValue.rawValue:
                state.futureValue = Double(field.text!) ?? 0.0
                break
                
            case TextFieldID.principalAmount.rawValue:
                state.principalAmount = Double(field.text!) ?? 0.0
                break
                
            case TextFieldID.interest.rawValue:
                let interest = Double(field.text!) ?? 0.0
                state.interest = interest / 100.0
                break
                
            case TextFieldID.duration.rawValue:
                state.duration = Double(field.text!) ?? 0
                break
                
            case TextFieldID.monthlyPayments.rawValue:
                state.monthlyPayment = Double(field.text!) ?? 0.0
                break
                
            default:
                break
        }
    }
}
