//
//  FieldSelectorSheetViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 30/3/22.
//

import UIKit

/// Reusable Picker component for selecting field needed to be found
class FieldSelectorSheetViewControlller : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedValue: TextFieldID?
    
    /// Previous value of picker to maintain state on cancel
    var previousValue: TextFieldID?
    
    /// Action to be completed after submitting selection
    var onCloseAction: ((_ selectedValue: TextFieldID?)->())?
    var fields: [TextFieldIdentity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lazy var confirmBtn: UIButton = {
            let view = UIButton()
            view.configuration = .filled()
            view.setTitle("Confirm", for: .normal)
            view.addTarget(self, action: #selector(onConfirm), for: .touchDown)
            
            return view
        }()
        
        lazy var cancelBtn: UIButton = {
            let view = UIButton()
            view.configuration = .tinted()
            view.tintColor = UIColor.systemRed
            view.setTitle("Cancel", for: .normal)
            view.addTarget(self, action: #selector(onCancel), for: .touchDown)
            
            return view
        }()
        
        lazy var btnPanel: UIStackView = {
            let view = UIStackView(arrangedSubviews: [cancelBtn, confirmBtn])
            view.axis = .horizontal
            view.spacing = 4.0
            
            return view
        }()
        
        lazy var pickerView: UIPickerView = {
            let view = UIPickerView()
            view.dataSource = self
            view.delegate = self
            view.selectRow(fields?.firstIndex(where: {$0.id == selectedValue})! ?? 0, inComponent: 0, animated: true)
            
            return view
        }()
        
        lazy var pickerContainer: UIStackView = {
            let view = UIStackView(arrangedSubviews: [pickerView, btnPanel])
            view.axis = .vertical
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.borderColor = UIColor.blue.cgColor
            view.layer.borderWidth = 1.0
            
            return view
        }()
        
        view.backgroundColor = UIColor.white
        view.addSubview(pickerContainer)
        
        NSLayoutConstraint.activate([
            pickerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 5.0)
        ])
    }
    
    @objc func onConfirm() {
        onCloseAction?(selectedValue)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onCancel(){
        onCloseAction?(previousValue)
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fields?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fields?[row].name
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = fields?[row].id
        view.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let vc = self.presentingViewController as? SavingsViewController {
            vc.savingsViewScrollView.isUserInteractionEnabled = true
        }
    }
    
    
}
