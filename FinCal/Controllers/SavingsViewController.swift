//
//  SavingsViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 8/3/22.
//

import UIKit

class SavingsViewController: UIViewController {

    @IBOutlet var principalAmountContainer: UIStackView!
    @IBOutlet var interestContainer: UIStackView!
    @IBOutlet var futureValueContainer: UIStackView!
    @IBOutlet var numberOfPaymentsContainer: UIStackView!

    @IBOutlet var fieldContainers: [UIStackView]!

    @IBOutlet var principalAmountTF: UITextField!
    @IBOutlet var interestTF: UITextField!
    @IBOutlet var futureValueTF: UITextField!
    @IBOutlet var numberOfPaymentsTF: UITextField!

    @IBOutlet var solvingFieldLabel: UILabel!

    @IBOutlet var answerTF: UITextField!

    @IBOutlet var onScreenAlertText: UILabel!
    @IBOutlet var pickSolvingFieldBtn: UIButton!
    @IBOutlet var savingsViewScrollView: UIScrollView!

    @IBOutlet var textFields: [UITextField]!

    @objc dynamic var missingField = TextFieldID.principalAmount.rawValue
    private var missingFieldObserver: NSKeyValueObservation?

    private let savingsViewModel = SimpleSavingsViewModel()
    private let fieldSelectorVC = FieldSelectorSheetViewControlller()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.hideKeyboardWhenSwipeDown()

        title = "Savings"

        onScreenAlertText.isHidden = false
        pickSolvingFieldBtn.addTarget(self, action: #selector(openFieldToSolveSelectionSheet), for: .touchDown)

        // To push view up when keyboard shows/hides
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenWhenKeyboardShows), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenWhenKeyboardHides), name: UIResponder.keyboardWillHideNotification, object: nil)


        // TODO: Action needs to be implemented here for the "Help View"
        let questionImage = UIImage(systemName: "questionmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .default))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: questionImage, style: .plain, target: self, action: nil)

        // Watches for change in the selected missing field
        missingFieldObserver = observe(\.missingField, options: [.new]) { [weak self] obj, change in
            self?.exposeRequiredFields(missingFieldTag: change.newValue!)
        }

        answerTF.isEnabled = false
        pickSolvingFieldBtn.subtitleLabel?.text = "Principal Amount"
        exposeRequiredFields(missingFieldTag: missingField)
        
    }

    func exposeRequiredFields(missingFieldTag: Int) {
        savingsViewModel.savings = SimpleSavings()

        if let missingTFContainer = fieldContainers.first(where: { $0.arrangedSubviews.last?.tag == missingFieldTag }),
           let missingTF = textFields.first(where: { $0.tag == missingFieldTag }),
           let missingTFLabel = (missingTFContainer.arrangedSubviews.first as? UILabel)?.text {
            missingTFContainer.isHidden = true
            pickSolvingFieldBtn.subtitleLabel?.text = missingTFLabel
            answerTF.text = missingTF.text
            answerTF.placeholder = missingTF.placeholder
        }

        let remainingFieldContainers = fieldContainers.filter({ $0.arrangedSubviews.last?.tag != missingFieldTag })
        remainingFieldContainers.forEach({
            $0.isHidden = false
        })
    }

    /// Opens a sheet that allows the user to pick the field they want to solve for
    @objc func openFieldToSolveSelectionSheet() {
        fieldSelectorVC.previousValue = fieldSelectorVC.selectedValue
        fieldSelectorVC.selectedValue = TextFieldID(rawValue: missingField)!
        fieldSelectorVC.onCloseAction = { [weak self] selectedValue in
            self?.savingsViewScrollView.isUserInteractionEnabled = true
            self?.missingField = selectedValue.rawValue
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
        updateFieldState(sender)
        
        switch missingField {
            case TextFieldID.futureValue.rawValue:
                let futureValue = savingsViewModel.savings.getFutureValue()
                savingsViewModel.savings.futureValue = futureValue
                answerTF.text = futureValue.description
                break
            case TextFieldID.interest.rawValue:
                let interest = savingsViewModel.savings.getRate()
                print(interest)
                answerTF.text = "\(interest.roundTo(decimalPlaces: 2) * 100)%"
                savingsViewModel.savings.interest = interest.roundTo(decimalPlaces: 2)
            case TextFieldID.principalAmount.rawValue:
                let principalAmount = savingsViewModel.savings.getPrincipalAmount()
                principalAmountTF.text = principalAmount.roundTo(decimalPlaces: 2).description
                savingsViewModel.savings.principalAmount = principalAmount
                break
            default:
                break
        }


    }

    func updateFieldState(_ field: UITextField) {
        switch field.tag {
        case TextFieldID.futureValue.rawValue:
            savingsViewModel.savings.futureValue = Double(field.text!) ?? 0.0
            break

        case TextFieldID.principalAmount.rawValue:
            savingsViewModel.savings.principalAmount = Double(field.text!) ?? 0.0
            break

        case TextFieldID.interest.rawValue:
            savingsViewModel.savings.interest = Double(Double(field.text!) ?? 0.0 / 100.0)
            break

        case TextFieldID.duration.rawValue:
            savingsViewModel.savings.duration = Int(field.text!) ?? 0
            break

        default:
            break
        }
    }
}
