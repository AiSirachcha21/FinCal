//
//  UIViewController+Extensions.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 10/3/22.
//

import UIKit

extension UIViewController {
    typealias FieldIdentity = (name: String, id: TextFieldID)

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func hideKeyboardWhenSwipeDown() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }

    func setupStatusBar() {
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        navigationController?.navigationBar.backgroundColor = UIColor.white
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func adjustScreenWhenKeyboardShows(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 40
            }
        }
    }

    @objc func adjustScreenWhenKeyboardHides(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
