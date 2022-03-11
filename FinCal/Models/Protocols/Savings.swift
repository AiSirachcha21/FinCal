//
//  Savings.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 10/3/22.
//

import Foundation

// Payables where a future value can be earned based on payments
protocol Savings : Payable {
    var futureValue: Double? { get set }
}
