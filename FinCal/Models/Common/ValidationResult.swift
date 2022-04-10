//
//  ValidationError.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 24/3/22.
//

import Foundation

class ValidationResult<T>: CustomStringConvertible {
    var message: String?
    var messages = [String]()
    var result: T
    var description = ""

    /// Validation Result without Message
    init(result: T) {
        self.result = result
        self.description = generateDescription(result: result, message: nil)
    }

    /// Validation Result with Message
    convenience init(result: T, message: String) {
        self.init(result: result)

        self.message = message
        self.description = generateDescription(result: result, message: message)
    }

    /// Validation Result with multiple Messages
    convenience init(result: T, messages: [String]) {
        self.init(result: result)

        self.messages = messages
        self.description = generateDescription(result: result, message: message)
    }

    private func generateDescription<T>(result: T, message: String?) -> String {
        let Type = T.self

        if let message = message {
            return "Validation Error<\(Type)> - result=\(result) message=\(message)"
        }

        return "Validation Error<\(Type)> - result=\(result)"
    }


}
