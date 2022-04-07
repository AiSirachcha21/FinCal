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
    
    @objc dynamic var missingField = TextFieldID.duration.rawValue
    private var missingFieldObserver: NSKeyValueObservation?
    
    private lazy var loanViewModel = LoanMortgageViewModel(state: Loan())
    private lazy var fieldSelectorVC = FieldSelectorSheetViewControlller()
    private lazy var selectableFields:[TextFieldIdentity] = [
        TextFieldIdentity(name: "Duration", id: TextFieldID.duration),
        TextFieldIdentity(name: "Monthly Payments", id: TextFieldID.monthlyPayments)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.hideKeyboardWhenSwipeDown()
        self.setupStatusBar()

        title = "Loan and Mortgages"
        self.addHelpPageNavigationButton(action: nil)
        
        // To push view up when keyboard shows/hides
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenWhenKeyboardShows), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenWhenKeyboardHides), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        changeFieldButton.addTarget(self, action: #selector(openFieldToSolveSelectionSheet), for: .touchDown)
        
        missingFieldObserver = observe(\.missingField, options: [.new]){ [weak self] obj, change in
            self?.exposeRequiredFields(missingFieldTag: change.newValue!)
        }
        
        changeFieldButton.subtitleLabel?.text = selectableFields.first(where: { $0.id.rawValue == missingField })?.name
        exposeRequiredFields(missingFieldTag: missingField)
    }
    
    func exposeRequiredFields(missingFieldTag: Int) {
        if let missingTFContainer = containers.first(where: { $0.arrangedSubviews.last?.tag == missingFieldTag }),
           let missingTF = textFields.first(where: { $0.tag == missingFieldTag }),
           let missingTFLabel = (missingTFContainer.arrangedSubviews.first as? UILabel)?.text {
            missingTFContainer.isHidden = true
            changeFieldButton.subtitleLabel?.text = missingTFLabel
            resultTF.text = missingTF.text
            resultTF.placeholder = missingTF.placeholder
            
            containers
                .filter({ $0.arrangedSubviews.last?.tag != missingFieldTag })
                .forEach({ $0.isHidden = false })
        }
    }
    
    @objc func openFieldToSolveSelectionSheet() {
        fieldSelectorVC.fields = [TextFieldIdentity](selectableFields)
        fieldSelectorVC.previousValue = fieldSelectorVC.selectedValue
        fieldSelectorVC.selectedValue = TextFieldID(rawValue: missingField)!
        fieldSelectorVC.onCloseAction = { [weak self] selectedValue in
            self?.scrollView.isUserInteractionEnabled = true
            
            if let newMissingFieldTag = selectedValue?.rawValue {
                self?.missingField = newMissingFieldTag
            } else {
                /* Do this to make sure that the button doesn't use the default text when you click cancel
                 * after attempting to pick field on first time */
                self?.changeFieldButton.subtitleLabel?.text = self?.selectableFields.first(
                    where: {$0.id.rawValue == self?.missingField }
                )?.name
            }
        }
        
        if let sheet = fieldSelectorVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        scrollView.isUserInteractionEnabled = false
        present(fieldSelectorVC, animated: true, completion: nil)
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
        
        resultTF.text = resultText ?? defaultErrorMessage
    }
}
