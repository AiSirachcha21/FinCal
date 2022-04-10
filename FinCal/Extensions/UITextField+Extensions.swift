//
//  UITextField+Extensions.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 11/3/22.
//

import Foundation
import UIKit

extension UITextField {
    func addNumericAccessory(addPlusMinus: Bool) {
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        numberToolbar.barStyle = UIBarStyle.default

        var accessories: [UIBarButtonItem] = []

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(numberPadDone))
        if addPlusMinus {
            let pmBtn = UIBarButtonItem(title: "+/-", style: UIBarButtonItem.Style.plain, target: self, action: #selector(plusMinusPressed))
            accessories.append(pmBtn)
        }
        accessories.append(contentsOf: [flexibleSpace, doneBtn])
        numberToolbar.sizeToFit()

        numberToolbar.items = accessories
        inputAccessoryView = numberToolbar
    }

    @objc func numberPadDone() {
        self.resignFirstResponder()
        self.sendActions(for: .editingDidEnd)
    }

    /// Action for Plus/Minus Toggle Button
    /// - Important: UITextField does not detect programmatic changes to text property. So sendActions function is required to manually send a notification to the UITextField.
    /// - SeeAlso: [sendActions Call](https://stackoverflow.com/questions/49918355/uitextfield-editing-changed-not-call)
    @objc func plusMinusPressed() {
        guard let currentText = self.text else {
            return
        }
        if currentText.hasPrefix("-") {
            let offsetIndex = currentText.index(currentText.startIndex, offsetBy: 1)
            let substring = currentText[offsetIndex...] // remove first character
            self.text = String(substring)
        } else {
            self.text = "-" + currentText
        }

        self.sendActions(for: .editingChanged)
    }
}
