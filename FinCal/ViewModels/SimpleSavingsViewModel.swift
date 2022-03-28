//
//  SimpleSavingsViewModel.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 24/3/22.
//

import Foundation
import UIKit
import RxRelay

class SimpleSavingsViewModel {
//    var canCalculateInterest = false
//    var canCalculateTimeInYears = false
//    var canCalculateInitialInvestment = false
    var canCalculate = false

    var savings = BehaviorRelay(value: SimpleSavings())
    
    func canCalculateInitialAmount() -> ValidationResult<Bool> {
        var errorMessages = [String]()
        
        if savings.value.futureValue > 0 && savings.value.interest >= 0 && savings.value.duration > 0  {
            return ValidationResult(result: true)
        }
        
        if savings.value.duration <= 0 {
            errorMessages.append("Duration needs to be greater than 0")
        }
        
        if savings.value.interest < 0 {
            errorMessages.append("Interest has to be 0 or greater")
        }
        
        if savings.value.futureValue <= 0.0 {
            errorMessages.append("Future Value has to be greater than 0")
        }
        
        return ValidationResult(result: false, messages: errorMessages)
    }

    func canCalculateInterest() -> ValidationResult<Bool> {
        var errorMessages = [String]()
        
        if savings.value.principalAmount > 0 || savings.value.futureValue > 0 || savings.value.duration > 0{
            return ValidationResult(result: true)
        }
        
        if savings.value.principalAmount <= 0.0 {
            errorMessages.append("Principal amount needs to be greater than 0")
        }
        
        if savings.value.interest < 0 {
            errorMessages.append("Interest has to be 0 or greater")
        }
        
        if savings.value.futureValue <= 0.0 {
            errorMessages.append("Future Value has to be greater than 0")
        }
        
        return ValidationResult(result: false, messages: errorMessages)
    }

    func canCalculateDurationRequiredInYears() -> ValidationResult<Bool> {
        var errorMessages = [String]()
        
        if savings.value.principalAmount > 0 && savings.value.futureValue > 0 && savings.value.interest >= 0 {
            return ValidationResult(result: true)
        }
        
        if savings.value.principalAmount <= 0.0 {
            errorMessages.append("Principal amount needs to be greater than 0")
        }
        
        if savings.value.interest < 0 {
            errorMessages.append("Interest has to be 0 or greater")
        }
        
        if savings.value.futureValue <= 0.0 {
            errorMessages.append("Future Value has to be greater than 0")
        }
        
        
        return ValidationResult(result: false, messages: errorMessages)
    }
}
