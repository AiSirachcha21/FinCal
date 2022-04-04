//
//  ViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 6/3/22.
//

import UIKit

class LoanMortgageViewController: UIViewController {
    @IBOutlet var resultTF: UITextField!
    @IBOutlet var loanAmountTF: UITextField!
    @IBOutlet var interestTF: UITextField!
    @IBOutlet var monthlyPaymentTF: UITextField!
    @IBOutlet var numberOfPaymentsTF: UITextField!
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet var changeFieldButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Loan and Mortgages"
        let questionImage = UIImage(systemName: "questionmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .default))

        // TODO: Action needs to be implemented here for the "Help View"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: questionImage, style: .plain, target: self, action: nil)
        // Do any additional setup after loading the view.
    }

}
