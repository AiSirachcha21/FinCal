//
//  UITextField+Extensions.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 11/3/22.
//

import Foundation
import UIKit

extension UITextField {
    func assignTFID (id: TextFieldID){
        self.tag = id.rawValue
    }
}
