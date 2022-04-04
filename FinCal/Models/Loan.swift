//
//  Loan.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 3/4/22.
//

import Foundation

class Loan : Payable {
    var principalAmount: Double = 0.0
    var interest: Double = 0.0
    var monthlyPayment: Double = 0.0
    var duration: Int = 1
}
