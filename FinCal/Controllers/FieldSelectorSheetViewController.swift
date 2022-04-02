//
//  FieldSelectorSheetViewController.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 30/3/22.
//

import UIKit

class FieldSelectorSheetViewControlller : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // Properties required from caller
    var selectedValue: TextFieldID?
    var previousValue: TextFieldID?
    var onCloseAction: ((_ selectedValue: TextFieldID)->())?
    
    // Data for picker
    let simpleSavingsFields = [(name:String, id:TextFieldID)](arrayLiteral: ("Principal Amount", TextFieldID.principalAmount), ("Future Value", TextFieldID.futureValue), ("Interest", TextFieldID.interest))
    
    // UI Elements
    var pickerView:UIPickerView?
    var pickerContainer = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIPickerView()
        
        let confirmBtn = UIButton()
        let cancelBtn = UIButton()
        
        cancelBtn.configuration = .tinted()
        cancelBtn.tintColor = UIColor.systemRed
        cancelBtn.setTitle("Cancel", for: .normal)
        
        confirmBtn.configuration = .filled()
        confirmBtn.setTitle("Confirm", for: .normal)
        
        confirmBtn.addTarget(self, action: #selector(onConfirm), for: .touchDown)
        cancelBtn.addTarget(self, action: #selector(onCancel), for: .touchDown)
        
        let btnPanel = UIStackView(arrangedSubviews: [cancelBtn, confirmBtn])
        btnPanel.axis = .horizontal
        btnPanel.spacing = 4.0
        
        pickerContainer.axis = .vertical
        pickerContainer.translatesAutoresizingMaskIntoConstraints = false
        pickerContainer.layer.borderColor = UIColor.blue.cgColor
        pickerContainer.layer.borderWidth = 1.0
        
        if let picker = pickerView {
            picker.dataSource = self
            picker.delegate = self
            picker.selectRow(simpleSavingsFields.firstIndex(where: {$0.id == selectedValue})!, inComponent: 0, animated: true)
            
            pickerContainer.addArrangedSubview(picker)
            pickerContainer.addArrangedSubview(btnPanel)
            
            view.backgroundColor = UIColor.white
            view.addSubview(pickerContainer)
            
            NSLayoutConstraint.activate([
                pickerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pickerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pickerContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 5.0)
            ])
        }
    }
    
    @objc func onConfirm() {
        onCloseAction?(selectedValue ?? TextFieldID.futureValue)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onCancel(){
        onCloseAction?(previousValue ?? TextFieldID.futureValue)
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return simpleSavingsFields.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return simpleSavingsFields[row].name
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = simpleSavingsFields[row].id
        view.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let vc = self.presentingViewController as? SavingsViewController {
            vc.savingsViewScrollView.isUserInteractionEnabled = true
        }
    }
    
    
}
