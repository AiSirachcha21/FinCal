//
//  SimpleSavingsViewModel.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 24/3/22.
//

import UIKit

class SimpleSavingsViewModel : StatefulViewModel<SimpleSavings> {
    func calculateFutureValue(withMonthlyPayments hasMonthlyPayments: Bool) -> String? {
        let futureValue = state.getFutureValue(withMonthlyPayments: hasMonthlyPayments)
        
        if isInvalidValue(futureValue) {
            return nil
        }
        
        state.futureValue = futureValue
        
        let formattedFutureValue = "£\(futureValue.roundTo(decimalPlaces: 2))"
        return formattedFutureValue
    }
    
    func calculateInterest(withMonthlyPayments hasMonthlyPayments: Bool) -> String? {
        let interest = state.getRate(withMonthlyPayments: hasMonthlyPayments)
        
        if isInvalidValue(interest) {
            return nil
        }
        
        state.interest = interest
        
        let formattedInterest = "\(interest.roundTo(decimalPlaces: 2) * 100)%"
        return formattedInterest
    }
    
    func calculatePrincipalAmount() -> String? {
        let principalAmount = state.getPrincipalAmount()
        
        if isInvalidValue(principalAmount) {
            return nil
        }
        
        state.principalAmount = principalAmount
        
        let formattedPrincipalAmount = "£\(principalAmount.roundTo(decimalPlaces: 2))"
        return formattedPrincipalAmount
    }
    
    func updateModelStateUsing(_ field: UITextField) {
        switch field.tag {
            case TextFieldID.futureValue.rawValue:
                state.futureValue = fabs(Double(field.text!) ?? 0.0)
                break
                
            case TextFieldID.principalAmount.rawValue:
                state.principalAmount = fabs(Double(field.text!) ?? 0.0)
                break
                
            case TextFieldID.interest.rawValue:
                let interest = fabs(Double(field.text!) ?? 0.0)
                state.interest = interest / 100.0
                break
                
            case TextFieldID.duration.rawValue:
                state.duration = fabs(Double(field.text!) ?? 0)
                break
                
            case TextFieldID.monthlyPayments.rawValue:
                state.monthlyPayment = fabs(Double(field.text!) ?? 0.0)
                break
                
            default:
                break
        }
    }
}
