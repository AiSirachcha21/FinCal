//
//  SavingsViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 8/3/22.
//

import UIKit

class SavingsViewController: UIViewController {

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

    @IBOutlet var textFields: [UITextField]!

    @objc dynamic var missingField = TextFieldID.futureValue.rawValue
    private var missingFieldObserver: NSKeyValueObservation?
    
    private var hasMonthlyPayments = false

    private lazy var savingsViewModel = SimpleSavingsViewModel(state: SimpleSavings())
    private lazy var fieldSelectorVC = FieldSelectorSheetViewControlller()
    private lazy var selectableFields = [
        TextFieldIdentity(name:"Principal Amount", id:TextFieldID.principalAmount),
        TextFieldIdentity(name:"Future Value", id:TextFieldID.futureValue),
        TextFieldIdentity(name:"Interest", id:TextFieldID.interest)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.hideKeyboardWhenSwipeDown()
        
        // Text color for Segemented Control
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        navigationController?.navigationBar.backgroundColor = UIColor.white
        
        title = "Savings"

        // TODO: Action needs to be implemented here for the "Help View"
        let questionImage = UIImage(systemName: "questionmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .default))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: questionImage, style: .plain, target: self, action: nil)
        
        
        // To push view up when keyboard shows/hides
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenWhenKeyboardShows), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenWhenKeyboardHides), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        pickSolvingFieldBtn.addTarget(self, action: #selector(openFieldToSolveSelectionSheet), for: .touchDown)

        // Watches for change in the selected missing field
        missingFieldObserver = observe(\.missingField, options: [.new]) { [weak self] obj, change in
            self?.exposeRequiredFields(missingFieldTag: change.newValue!)
        }
        
        answerTF.isEnabled = false
        pickSolvingFieldBtn.subtitleLabel?.text = selectableFields.first(where: { $0.id.rawValue == missingField })?.name
        exposeRequiredFields(missingFieldTag: missingField)
    }
    
    @IBAction func changeSavingsType() {
        hasMonthlyPayments = compoundSavingSwitcher.selectedSegmentIndex == 1
        exposeRequiredFields(missingFieldTag: missingField)
        calculateMissingField()
    }

    func exposeRequiredFields(missingFieldTag: Int) {
        if let missingTFContainer = fieldContainers.first(where: { $0.arrangedSubviews.last?.tag == missingFieldTag }),
           let missingTF = textFields.first(where: { $0.tag == missingFieldTag }),
           let missingTFLabel = (missingTFContainer.arrangedSubviews.first as? UILabel)?.text {
            missingTFContainer.isHidden = true
            pickSolvingFieldBtn.subtitleLabel?.text = missingTFLabel
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
    @objc func openFieldToSolveSelectionSheet() {
        fieldSelectorVC.fields = [TextFieldIdentity](selectableFields)
        fieldSelectorVC.previousValue = fieldSelectorVC.selectedValue
        fieldSelectorVC.selectedValue = TextFieldID(rawValue: missingField)!
        fieldSelectorVC.onCloseAction = { [weak self] selectedValue in
            self?.savingsViewScrollView.isUserInteractionEnabled = true
            
            if let newMissingFieldTag = selectedValue?.rawValue {
                self?.missingField = newMissingFieldTag
            } else {
                /* Do this to make sure that the button doesn't use the default text when you click cancel
                  * after attempting to pick field on first time */
                self?.pickSolvingFieldBtn.subtitleLabel?.text = self?.selectableFields.first(
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

        savingsViewScrollView.isUserInteractionEnabled = false
        present(fieldSelectorVC, animated: true, completion: nil)
    }

    @IBAction func onEdit(_ sender: UITextField) {
        savingsViewModel.updateModelStateUsing(sender)
        calculateMissingField()
    }
    
    func calculateMissingField(){
        switch missingField {
            case TextFieldID.futureValue.rawValue:
                answerTF.text = savingsViewModel.calculateFutureValue(withMonthlyPayments: hasMonthlyPayments)
                break
            case TextFieldID.interest.rawValue:
                answerTF.text = savingsViewModel.calculateInterest(withMonthlyPayments: hasMonthlyPayments)
                break
            case TextFieldID.principalAmount.rawValue:
                answerTF.text = savingsViewModel.calculatePrincipalAmount()
                break
            default:
                break
        }
    }
}
