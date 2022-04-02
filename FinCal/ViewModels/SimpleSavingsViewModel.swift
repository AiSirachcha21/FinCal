//
//  SimpleSavingsViewModel.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 24/3/22.
//

import Foundation
import UIKit

class SimpleSavingsViewModel {
//    var canCalculateInterest = false
//    var canCalculateTimeInYears = false
//    var canCalculateInitialInvestment = false
    var canCalculate = false

    var savings = SimpleSavings()
    
    func canCalculateInitialAmount() -> ValidationResult<Bool> {
        var errorMessages = [String]()
        
        if savings.futureValue > 0 && savings.interest >= 0 && savings.duration > 0  {
            return ValidationResult(result: true)
        }
        
        if savings.duration <= 0 {
            errorMessages.append("Duration needs to be greater than 0")
        }
        
        if savings.interest < 0 {
            errorMessages.append("Interest has to be 0 or greater")
        }
        
        if savings.futureValue <= 0.0 {
            errorMessages.append("Future Value has to be greater than 0")
        }
        
        return ValidationResult(result: false, messages: errorMessages)
    }

    func canCalculateInterest() -> ValidationResult<Bool> {
        var errorMessages = [String]()
        
        if savings.principalAmount > 0 || savings.futureValue > 0 || savings.duration > 0{
            return ValidationResult(result: true)
        }
        
        if savings.principalAmount <= 0.0 {
            errorMessages.append("Principal amount needs to be greater than 0")
        }
        
        if savings.interest < 0 {
            errorMessages.append("Interest has to be 0 or greater")
        }
        
        if savings.futureValue <= 0.0 {
            errorMessages.append("Future Value has to be greater than 0")
        }
        
        return ValidationResult(result: false, messages: errorMessages)
    }

    func canCalculateDurationRequiredInYears() -> ValidationResult<Bool> {
        var errorMessages = [String]()
        
        if savings.principalAmount > 0 && savings.futureValue > 0 && savings.interest >= 0 {
            return ValidationResult(result: true)
        }
        
        if savings.principalAmount <= 0.0 {
            errorMessages.append("Principal amount needs to be greater than 0")
        }
        
        if savings.interest < 0 {
            errorMessages.append("Interest has to be 0 or greater")
        }
        
        if savings.futureValue <= 0.0 {
            errorMessages.append("Future Value has to be greater than 0")
        }
        
        
        return ValidationResult(result: false, messages: errorMessages)
    }
}
