//
//  ViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 6/3/22.
//

import UIKit

class LoanMortgageViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var resultTF: UITextField!
    @IBOutlet var loanAmountTF: UITextField!
    @IBOutlet var interestTF: UITextField!
    @IBOutlet var monthlyPaymentTF: UITextField!
    @IBOutlet var numberOfPaymentsTF: UITextField!
    
    @IBOutlet var loanContainer: UIStackView!
    @IBOutlet var interestContainer: UIStackView!
    @IBOutlet var monthlyPayment: UIStackView!
    @IBOutlet var numberOfPaymentsContainer: UIStackView!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var containers: [UIStackView]!
    
    @IBOutlet var changeFieldButton: UIButton!
    
    @IBOutlet var durationTypeController: UISegmentedControl!
    
    @IBOutlet var missingFieldLabel: UILabel!
    @objc dynamic var missingField = TextFieldID.duration.rawValue
    private var missingFieldObserver: NSKeyValueObservation?
    private var fieldSelectorVC: FieldSelectorSheetViewControlller?
    
    private lazy var loanViewModel = LoanMortgageViewModel(state: Loan())
    private lazy var selectableFields:[TextFieldIdentity] = [
        TextFieldIdentity(name: "Duration", id: TextFieldID.duration),
        TextFieldIdentity(name: "Monthly Payments", id: TextFieldID.monthlyPayments)
    ]
    private lazy var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setupStatusBar()

        title = "Loan and Mortgages"
        
        // To push view up when keyboard shows/hides
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenWhenKeyboardShows), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenWhenKeyboardHides), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        missingFieldObserver = observe(\.missingField, options: [.new]){ [weak self] obj, change in
            self?.exposeRequiredFields(missingFieldTag: change.newValue!)
            self?.durationTypeController.isHidden = change.newValue! != TextFieldID.duration.rawValue
            self?.missingFieldLabel.text = self?.selectableFields.first(where: { $0.id.rawValue == self?.missingField })?.name
        }
        
        missingFieldLabel.text = selectableFields[0].name
        exposeRequiredFields(missingFieldTag: missingField)
        
        self.recoverFieldsFromMemory()
    }
    
    /// Recover fields from memory when the application re-launches from inactive, background  or suspended state.
    func recoverFieldsFromMemory(){
        if let loanData = UserDefaults.standard.data(forKey: UserDefaultKeys.loans),
           let loan = try? JSONDecoder().decode(Loan.self, from: loanData) {
            loanViewModel.state = loan
            
            loanAmountTF.text = loan.principalAmount.roundTo(decimalPlaces: 2).description
            interestTF.text = Int(loan.interest * 100).description
            monthlyPaymentTF.text = loan.monthlyPayment.roundTo(decimalPlaces: 2).description
            numberOfPaymentsTF.text = loan.duration.description
            
            missingField = TextFieldID.duration.rawValue
        }
    }
    
    @IBAction func onDurationTypeChange(_ sender: UISegmentedControl) {
        loanViewModel.durationInYears = sender.selectedSegmentIndex == 0
        calculateMissingField()
    }
    
    func exposeRequiredFields(missingFieldTag: Int) {
        if let missingTFContainer = containers.first(where: { $0.arrangedSubviews.last?.tag == missingFieldTag }),
           let missingTF = textFields.first(where: { $0.tag == missingFieldTag }),
           let missingTFLabel = (missingTFContainer.arrangedSubviews.first as? UILabel)?.text {
            missingTFContainer.isHidden = true
            
            missingFieldLabel.text = missingTFLabel
            resultTF.text = missingTF.text
            resultTF.placeholder = missingTF.placeholder
            
            containers
                .filter({ $0.arrangedSubviews.last?.tag != missingFieldTag })
                .forEach({ $0.isHidden = false })
        }
    }
    
    @IBAction func openFieldToSolveSelectionSheet() {
        func handleClose(selectedValue:TextFieldID?) {
            self.scrollView.isUserInteractionEnabled = true
            self.changeFieldButton.isEnabled = true
            
            if let newMissingFieldTag = selectedValue?.rawValue {
                self.missingField = newMissingFieldTag
            }
        }
        
        fieldSelectorVC = FieldSelectorSheetViewControlller()
        fieldSelectorVC!.fields = [TextFieldIdentity](selectableFields)
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
        
        scrollView.isUserInteractionEnabled = false
        changeFieldButton.isEnabled = false
        
        present(fieldSelectorVC!, animated: true)
    }

    @IBAction func onEdit(_ sender: UITextField) {
        loanViewModel.updateModelStateUsing(sender)
        calculateMissingField()
    }
    
    func calculateMissingField(){
        let defaultErrorMessage = "Cannot be calculated"
        var resultText: String?
        
        switch missingField {
            case TextFieldID.duration.rawValue:
                resultText = loanViewModel.calculateTimeToFinishLoan()
                break
            case TextFieldID.monthlyPayments.rawValue:
                resultText = loanViewModel.getMonthlyPaymentForDuration()
                break
            default:
                break
        }
        
        if resultText != nil {
            if let encodedState = try? JSONEncoder().encode(loanViewModel.state) {
                userDefaults.set(encodedState, forKey: UserDefaultKeys.loans)
            }
        }
        
        resultTF.text = resultText ?? defaultErrorMessage
    }
}
