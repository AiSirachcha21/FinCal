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
        
        return getFieldStringRepr(fieldTag: .futureValue, value: futureValue)
    }
    
    func calculateInterest(withMonthlyPayments hasMonthlyPayments: Bool) -> String? {
        let interest = state.getRate(withMonthlyPayments: hasMonthlyPayments)
        
        if isInvalidValue(interest) {
            return nil
        }
        
        state.interest = interest
        
        return getFieldStringRepr(fieldTag: .interest, value: interest)
    }
    
    func calculatePrincipalAmount(withMonthlyPayments hasMonthlyPayments: Bool) -> String? {
        let principalAmount = state.getPrincipalAmount(withMonthlyPayments: hasMonthlyPayments)
        
        if isInvalidValue(principalAmount) {
            return nil
        }
        
        state.principalAmount = principalAmount
        
        return getFieldStringRepr(fieldTag: .principalAmount, value: principalAmount)
    }
    
    func calculateDuration(withMonthlyPayments hasMonthlyPayments: Bool) -> String? {
        let duration = state.getDuration(withMonthlyPayments: hasMonthlyPayments)
        
        if isInvalidValue(duration) {
            return nil
        }
        
        state.duration = duration
    
        if durationInYears {
            let years = duration / 12
            let formattedYears = Int(years.roundTo(decimalPlaces: 2))
            
            let monthDecimal = years.truncatingRemainder(dividingBy: 1)
            let months = Int((monthDecimal * 12).rounded(.up))
            
            return getFieldStringRepr(fieldTag: .duration, value: (formattedYears, months))
        }
        
        return "\(duration * 12) months"
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
