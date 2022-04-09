//
//  LoanMortgageViewModel.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 3/4/22.
//

import UIKit

enum LoanTimeFormat {
    case months
    case years
}

class LoanMortgageViewModel : StatefulViewModel<Loan> {
    func calculateTimeToFinishLoan(returnAs:LoanTimeFormat = .years) -> String? {
        let mortgageDuration = state.getMortgageDuration()
        
        if mortgageDuration.isNaN || mortgageDuration.isInfinite {
            return nil
        }
        
        state.duration = mortgageDuration
        
        if returnAs == .months {
            return "\(abs(mortgageDuration)) months"
        }
        
        let years = mortgageDuration / 12
        let formattedYears = Int(years.roundTo(decimalPlaces: 2))
        
        let monthDecimal = years.truncatingRemainder(dividingBy: 1)
        let months = Int((monthDecimal * 12).rounded(.up))
        
        return getFieldStringRepr(fieldTag: .duration, value: (formattedYears, months))
    }
    
    /// Returns Monthly Payment Rounded to 2 Decimal Places as a String
    func getMonthlyPaymentForDuration() -> String? {
        let monthlyPayment = state.getMortgagePayment()
        
        if monthlyPayment.isNaN || monthlyPayment.isInfinite {
            return nil
        }
        
        state.monthlyPayment = monthlyPayment
        return getFieldStringRepr(fieldTag: .monthlyPayments, value: monthlyPayment)
    }
    
    func updateModelStateUsing(_ field: UITextField) {
        switch field.tag {
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
