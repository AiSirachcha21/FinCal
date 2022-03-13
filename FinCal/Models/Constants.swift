//
//  Constants.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 6/3/22.
//

import Foundation

enum ScreenNames {
    static let savingScreen = "Savings"
    static let loanMortgageScreen = "Loan & Mortgage"
    static let compoundInterestScreen = "Compound Savings"
}

enum TextFieldID: Int {
    case futureValue = 1
    case interest = 2
    case principalAmount = 3
    case numberOfPayments = 4
    case duration = 5
}
