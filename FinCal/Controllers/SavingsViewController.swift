//
//  SavingsViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 8/3/22.
//

import UIKit
import RxSwift
import RxCocoa

struct SavingFormFieldObservables {
    var principalAmount: Observable<Optional<String>>
}

class SavingsViewController: UIViewController {
    
    @IBOutlet var principalAmountTF: UITextField!
    
    private var disposeBag = DisposeBag()
    private var simpleSavings = SimpleSavings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.hideKeyboardWhenSwipeDown()
        
        title = "Savings"
        
        // TODO: Action needs to be implemented here for the "Help View"
        let questionImage = UIImage(systemName: "questionmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .default))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: questionImage, style: .plain, target: self, action: nil)
        
        //        simpleSavingsFormFields.forEach { $0.addNumericAccessory(addPlusMinus: true) }q
        let observables = setupInputBindings()
        setupSubscriptions(observables)
        
    }
    
    func setupInputBindings() -> SavingFormFieldObservables {
        let principleAmount = principalAmountTF
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
        
        return SavingFormFieldObservables(principalAmount: principleAmount)
    }
    
    func setupSubscriptions(_ observables: SavingFormFieldObservables) {
        observables.principalAmount
            .debounce(.milliseconds(1500), scheduler: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { [weak self] value in
                    guard let text = value else {
                        self?.simpleSavings.principalAmount = 0.0
                        return
                    }
                    self?.simpleSavings.principalAmount = Double(text) ?? 0.0
                    
                    print(self?.simpleSavings.principalAmount ?? "Nothing here")
                },
                onError: { _ in },
                onCompleted: nil,
                onDisposed: nil )
            .disposed(by: disposeBag)
    }
}
