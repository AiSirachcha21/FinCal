//
//  TextFieldIdentity.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 4/4/22.
//

import Foundation

class TextFieldIdentity: NSObject {
    var name: String
    var id: TextFieldID

    init(name: String, id: TextFieldID) {
        self.name = name
        self.id = id
    }
}
