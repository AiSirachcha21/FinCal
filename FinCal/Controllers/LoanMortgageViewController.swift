//
//  ViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 6/3/22.
//

import UIKit

class LoanMortgageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Loan and Mortgages"
        let questionImage = UIImage(systemName: "questionmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .default))
        
        //TODO: Action needs to be implemented here for the "Help View"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: questionImage, style: .plain, target: self, action: nil)
        // Do any additional setup after loading the view.
    }


}

