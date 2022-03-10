//
//  MonthlyPayable.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 10/3/22.
//

import Foundation

/// These are payables where a monthly payment is required
protocol MonthlyPayable: Payable {
    var monthlyPayment: Double { get set }
}
