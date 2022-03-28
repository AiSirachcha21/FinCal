//
//  SavingsViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 8/3/22.
//

import UIKit
import RxSwift

//class SavingFormFieldObservables {
//    var principalAmount: Observable<Optional<String>>?
//    var interest: Observable<Optional<String>>?
//    var duration: Observable<Optional<String>>?
//    var futureValue: Observable<Optional<String>>?
//    var numberOfPayments: Observable<Optional<String>>?
//    
//    init() {
//    }
//}

class SavingsViewController: UIViewController {
    
    @IBOutlet var principalAmountTF: UITextField!
    @IBOutlet var interestTF: UITextField!
    @IBOutlet var futureValueTF: UITextField!
    @IBOutlet var numberOfPaymentsTF: UITextField!
    @IBOutlet var onScreenAlertText: UILabel!
    
    @IBOutlet var textFields: [UITextField]!
    
    private var savingsViewModel = SimpleSavingsViewModel()
    private var disposeBag = DisposeBag()
    
    private var insufficientFields = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.hideKeyboardWhenSwipeDown()
        
        title = "Savings"
        
        onScreenAlertText.isHidden = insufficientFields
        onScreenAlertText.text = "One or more fields are required to do the calculation"
        onScreenAlertText.textColor = UIColor.red
        
        
        // TODO: Action needs to be implemented here for the "Help View"
        let questionImage = UIImage(systemName: "questionmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .default))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: questionImage, style: .plain, target: self, action: nil)
    }
    
    
    @IBAction func onEdit(_ sender: UITextField) {
        parseTextFieldValueToObject(sender)
        hasSufficientFieldsForCalculation(fieldsToCheck: textFields)
        
        if !insufficientFields {
            let missingField = textFields.first(where: { $0.text!.isEmpty })
            
            if let missingFieldTag = missingField?.tag  {
                print(missingFieldTag)
                switch missingFieldTag {
                    case TextFieldID.futureValue.rawValue:
                        let futureValue = savingsViewModel.savings.getFutureValue()
                        futureValueTF.text = futureValue.description
                        savingsViewModel.savings.futureValue = futureValue
                        break
                    case TextFieldID.interest.rawValue:
                        let savings = savingsViewModel.savings
                        let interest = savingsViewModel.savings.getRate(initialAmount: savings.principalAmount, futureAmount: savings.futureValue, duration: savings.duration)
                        interestTF.text = interest.roundTo(decimalPlaces: 2).description
                        savingsViewModel.savings.interest = interest.roundTo(decimalPlaces: 2)
                    default:
                        break
                }
            }
        }
    }
    
    func parseTextFieldValueToObject(_ field: UITextField) {
        switch field.tag {
            case TextFieldID.futureValue.rawValue:
                savingsViewModel.savings.futureValue = Double(field.text!) ?? 0.0
                break
                
            case TextFieldID.principalAmount.rawValue:
                savingsViewModel.savings.principalAmount = Double(field.text!) ?? 0.0
                break
                
            case TextFieldID.interest.rawValue:
                savingsViewModel.savings.interest = Double(field.text!) ?? 0.0
                break
                
            case TextFieldID.duration.rawValue:
                savingsViewModel.savings.duration = Int(field.text!) ?? 0
                break
            
            default:
                break
        }
    }
    
    
    func hasSufficientFieldsForCalculation(fieldsToCheck: [UITextField]) {
        //TODO: Check for Future Value Calculation is not done here. Implement
        //CHECK: Interest calculation seems to be working but changing the duration doesn't seem to affect it.
        let canCalculateInitialAmount = savingsViewModel.canCalculateInitialAmount()
        let canCalculateInterest = savingsViewModel.canCalculateInterest()
        let canCalculateDurationRequiredInYears = savingsViewModel.canCalculateDurationRequiredInYears()
        let allFieldsAreEmpty = [futureValueTF,numberOfPaymentsTF,principalAmountTF,interestTF].allSatisfy({ $0.text!.isEmpty })
        
        if allFieldsAreEmpty || !canCalculateInitialAmount.result || !canCalculateInterest.result || !canCalculateDurationRequiredInYears.result {
            insufficientFields = true
            onScreenAlertText.isHidden = false
            return
        }
        
        insufficientFields = false
        onScreenAlertText.isHidden = true
    }
    
    
}
