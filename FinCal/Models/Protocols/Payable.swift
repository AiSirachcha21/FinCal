//
//  Payment.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 10/3/22.
//

import Foundation

protocol Payable {
    /// Initial amount placed on any payment
    var principalAmount:Double { get set }
    
    /// Interest placed on payment or recievable
    /// - Note: Must be provided in floating point format
    var interest: Double { get set }
    
    /// Total number of payments required
    var numberOfPayments: Int { get set }
    
}
