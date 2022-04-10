//
//  LoanMortgageViewModel.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 3/4/22.
//

import UIKit

class LoanMortgageViewModel: StatefulViewModel<Loan> {
    func calculateTimeToFinishLoan() -> String? {
        let mortgageDuration = state.getMortgageDuration()

        if isInvalidValue(mortgageDuration) {
            return nil
        }

        state.duration = mortgageDuration

        if durationInYears {
            let years = Int(mortgageDuration)
            let months = Int((mortgageDuration - Double(years)) * 12)

            return getFieldStringRepr(fieldTag: .duration, value: (years, months))
        }

        return "\((mortgageDuration * 12).roundTo(decimalPlaces: 2)) months"
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

    func reassign(fields textFields: [UITextField]) {
        for textField in textFields {
            var text = ""
            switch textField.tag {
            case TextFieldID.principalAmount.rawValue:
                text = state.principalAmount.roundTo(decimalPlaces: 2).description
                break

            case TextFieldID.interest.rawValue:
                text = state.interest.roundTo(decimalPlaces: 2).description
                break

            case TextFieldID.duration.rawValue:
                text = state.duration.roundTo(decimalPlaces: 2).description
                break

            case TextFieldID.monthlyPayments.rawValue:
                text = state.monthlyPayment.roundTo(decimalPlaces: 2).description
                break

            default:
                text = (0.0).description
                break
            }

            textField.text = text
        }
    }

    func reassign(_ field: UITextField) {
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
