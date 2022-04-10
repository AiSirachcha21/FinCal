//
//  SavingsViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 8/3/22.
//

import UIKit

class SavingsViewController: UIViewController, UISheetPresentationControllerDelegate {

    @IBOutlet var compoundSavingSwitcher: UISegmentedControl!
    
    @IBOutlet var principalAmountContainer: UIStackView!
    @IBOutlet var interestContainer: UIStackView!
    @IBOutlet var futureValueContainer: UIStackView!
    @IBOutlet var numberOfPaymentsContainer: UIStackView!
    @IBOutlet var monthlyPaymentContainer: UIStackView!
    
    @IBOutlet var fieldContainers: [UIStackView]!

    @IBOutlet var principalAmountTF: UITextField!
    @IBOutlet var interestTF: UITextField!
    @IBOutlet var futureValueTF: UITextField!
    @IBOutlet var numberOfPaymentsTF: UITextField!
    @IBOutlet var monthlyPaymentTF: UITextField!
    
    @IBOutlet var answerTF: UITextField!

    @IBOutlet var pickSolvingFieldBtn: UIButton!
    @IBOutlet var savingsViewScrollView: UIScrollView!

    @IBOutlet var durationTypeController: UISegmentedControl!
    
    @IBOutlet var textFields: [UITextField]!

    @IBOutlet var missingFieldLabel: UILabel!
    @objc dynamic var missingField = TextFieldID.futureValue.rawValue
    private var missingFieldObserver: NSKeyValueObservation?
    
    private var hasMonthlyPayments = false
    private var fieldSelectorVC: FieldSelectorSheetViewController?

    private lazy var savingsViewModel = SavingsViewModel(state: Savings())
    private lazy var selectableFields = [
        TextFieldIdentity(name:"Principal Amount", id: .principalAmount),
        TextFieldIdentity(name:"Future Value", id: .futureValue),
        TextFieldIdentity(name:"Interest", id: .interest),
        TextFieldIdentity(name:"Duration", id: .duration)
    ]
    private lazy var selectableFieldsForMonthlyContributions = [
        TextFieldIdentity(name:"Principal Amount", id: .principalAmount),
        TextFieldIdentity(name:"Future Value", id: .futureValue),
        TextFieldIdentity(name:"Duration", id: .duration)
    ]
    
    private lazy var userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setupStatusBar()
        
        title = "Savings"
        
        // To push view up when keyboard shows/hides
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenWhenKeyboardShows), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenWhenKeyboardHides), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Watches for change in the selected missing field
        missingFieldObserver = observe(\.missingField, options: [.new]) { [weak self] obj, change in
            self?.exposeRequiredFields(missingFieldTag: change.newValue!)
            self?.durationTypeController.isHidden = change.newValue! != TextFieldID.duration.rawValue
            self?.missingFieldLabel.text = self?.selectableFields.first(where: { $0.id.rawValue == self?.missingField })?.name
        }
        
        missingFieldLabel.text = selectableFields.first(where: { $0.id.rawValue == missingField })?.name
        
        for tf in textFields {
            if tf.tag == TextFieldID.monthlyPayments.rawValue {
                tf.addNumericAccessory(addPlusMinus: true)
                continue
            }
            
            tf.addNumericAccessory(addPlusMinus: false)
        }
        
        exposeRequiredFields(missingFieldTag: missingField)
        self.recoverFieldsFromMemory()
    }
    
    /// Recover fields from memory when the application re-launches from inactive, background  or suspended state.
    func recoverFieldsFromMemory(){
        if let savingsData = UserDefaults.standard.data(forKey: UserDefaultKeys.savings),
           let savings = try? JSONDecoder().decode(Savings.self, from: savingsData) {
            savingsViewModel.state = savings
            
            principalAmountTF.text = savings.principalAmount.roundTo(decimalPlaces: 2).description
            interestTF.text = Int(savings.interest * 100).description
            futureValueTF.text = savings.futureValue.roundTo(decimalPlaces: 2).description
            monthlyPaymentTF.text = savings.monthlyPayment.roundTo(decimalPlaces: 2).description
            numberOfPaymentsTF.text = Int(savings.duration).description
            
            missingField = TextFieldID.futureValue.rawValue
        }
    }
    
    
    @IBAction func onDurationTypeChange(_ sender: UISegmentedControl) {
        savingsViewModel.durationInYears = sender.selectedSegmentIndex == 0
        calculateMissingField()
    }
    
    @IBAction func changeSavingsType() {
        hasMonthlyPayments = compoundSavingSwitcher.selectedSegmentIndex == 1
        if hasMonthlyPayments && missingField == TextFieldID.interest.rawValue {
            missingField = TextFieldID.duration.rawValue
        }
        exposeRequiredFields(missingFieldTag: missingField)
        calculateMissingField()
    }

    func exposeRequiredFields(missingFieldTag: Int) {
        if let missingTFContainer = fieldContainers.first(where: { $0.arrangedSubviews.last?.tag == missingFieldTag }),
           let missingTF = textFields.first(where: { $0.tag == missingFieldTag }),
           let missingTFLabel = (missingTFContainer.arrangedSubviews.first as? UILabel)?.text {
            
            savingsViewModel.reassign(fields: textFields)
            
            missingTFContainer.isHidden = true
            missingFieldLabel.text = missingTFLabel
            answerTF.text = missingTF.text
            answerTF.placeholder = missingTF.placeholder
            
            fieldContainers
                .filter({ $0.arrangedSubviews.last?.tag != missingFieldTag })
                .forEach({ $0.isHidden = false })
            
            monthlyPaymentTF.isEnabled = hasMonthlyPayments && missingTF.tag != TextFieldID.monthlyPayments.rawValue
            monthlyPaymentContainer.isHidden = !hasMonthlyPayments
        }
    }

    /// Opens a sheet that allows the user to pick the field they want to solve for
    @IBAction func openFieldToSolveSelectionSheet() {
        func handleClose(selectedValue:TextFieldID?) {
            self.savingsViewScrollView.isUserInteractionEnabled = true
            self.pickSolvingFieldBtn.isEnabled = true
            
            if let newMissingFieldTag = selectedValue?.rawValue {
                self.missingField = newMissingFieldTag
            }
        }
        
        fieldSelectorVC = FieldSelectorSheetViewController()
        fieldSelectorVC!.fields = [TextFieldIdentity](hasMonthlyPayments ? selectableFieldsForMonthlyContributions : selectableFields)
        fieldSelectorVC!.selectedValue = TextFieldID(rawValue: missingField)!
        fieldSelectorVC!.onCloseAction = handleClose
        fieldSelectorVC!.isModalInPresentation = true

        if let sheet = fieldSelectorVC!.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }

        savingsViewScrollView.isUserInteractionEnabled = false
        pickSolvingFieldBtn.isEnabled = false
        
        present(fieldSelectorVC!, animated: true)
    }

    @IBAction func onEdit(_ sender: UITextField) {
        savingsViewModel.reassign(sender)
        calculateMissingField()
    }
    
    func calculateMissingField(){
        let defaultErrorMessage = "Cannot be calculated"
        var resultText: String?
        
        switch missingField {
            case TextFieldID.futureValue.rawValue:
                resultText = savingsViewModel.calculateFutureValue(withMonthlyPayments: hasMonthlyPayments)
                break
            case TextFieldID.interest.rawValue:
                resultText = savingsViewModel.calculateInterest(withMonthlyPayments: hasMonthlyPayments)
                break
            case TextFieldID.principalAmount.rawValue:
                resultText = savingsViewModel.calculatePrincipalAmount(withMonthlyPayments: hasMonthlyPayments)
                break
            case TextFieldID.duration.rawValue:
                resultText = savingsViewModel.calculateDuration(withMonthlyPayments: hasMonthlyPayments)
                break
            default:
                break
        }
        
        if resultText != nil {
            if let encodedState = try? JSONEncoder().encode(savingsViewModel.state) {
                userDefaults.set(encodedState, forKey: UserDefaultKeys.savings)
            }
        }
        
        answerTF.text = resultText ?? defaultErrorMessage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
