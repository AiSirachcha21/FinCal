//
//  StatefulViewModel.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 4/4/22.
//

import Foundation
class StatefulViewModel<T> {
    var state: T
    
    init(state: T){
        self.state = state
    }
    
    func isInvalidValue(_ value: Double) -> Bool {
        return value.isNaN || value.isInfinite
    }
    
    func isInvalidValue(_ value: Decimal) -> Bool {
        return value.isNaN || value.isInfinite
    }
    
    func getFieldStringRepr(fieldTag: TextFieldID, value: Double) -> String {
        var string = "0.0"
        switch fieldTag {
            case .futureValue, .principalAmount, .monthlyPayments:
                string = "£\(value.roundTo(decimalPlaces: 2))"
                break
                
            case .interest:
                string = "\(value.roundTo(decimalPlaces: 2) * 100)%"
                break
                
            default:
                string = "£0.0"
                break
        }
        
        return string
    }
    
    func getFieldStringRepr(fieldTag: TextFieldID, value: Int) -> String {
        return value.description
    }
}
