//
//  SavingsViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 8/3/22.
//

import UIKit
import Combine

class SavingsViewController: UIViewController {
    @IBOutlet var simpleSavingsFormFields: [UITextField]!
    
    @Published var simpleSavings = SimpleSavings(principalAmount: 0.0)
    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.hideKeyboardWhenSwipeDown()
        
        title = "Savings"
        
        //TODO: Action needs to be implemented here for the "Help View"
        let questionImage = UIImage(systemName: "questionmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .default))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: questionImage, style: .plain, target: self, action: nil)
    }
    
    //TODO: Fields auto detect when changing principal value or interest rate. Must test with other fields
    //TODO: Make sure reverse works (predicting principal value or interest when other fields are entered)
    //TODO: Optimize code by finding a better way to implement Combine and moving commonly used code to classes/structs
    @IBAction func onEdited(_ sender: UITextField) {
        if let senderText = sender.text {
            switch sender.tag {
                case TextFieldID.principalAmount.rawValue:
                    self.simpleSavings.principalAmount = Double(senderText) ?? 0.0
                    break
                case TextFieldID.interest.rawValue:
                    self.simpleSavings.interest = (Double(senderText) ?? 0.0)/100
                    break
                default:
                    return
            }
        }
        
        self.cancellable = self.$simpleSavings
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main, options: .none)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let formFields = self?.simpleSavingsFormFields else { return }
                
                formFields.first(where: {text in
                    return text.tag == TextFieldID.futureValue.rawValue})?.text = value.getFutureValue(updateOriginal: true).roundTo(decimalPlaces: 2).description
                
                formFields.first(where: {text in
                    return text.tag == TextFieldID.numberOfPayments.rawValue})?.text = value.numberOfPayments.description
                
                formFields.first(where: {text in
                    return text.tag == TextFieldID.duration.rawValue})?.text = value.duration.description
                
                formFields.first(where: {text in
                    return text.tag == TextFieldID.interest.rawValue})?.text = value.getInterestRateAsPercentage().description
            })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cancellable?.cancel()
    }
}
