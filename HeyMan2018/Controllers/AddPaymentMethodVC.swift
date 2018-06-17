//
//  AddPaymentMethod.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddPaymentMethodVC: UIViewController {
    
    @IBOutlet weak var bankInput: UITextField!
    @IBOutlet weak var currencyInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    @IBOutlet weak var addMethodBtn: UIButton!
    
    private let bankPicker = InputFieldPicker(pickItems: Bank.all)
    private let currencyPicker = InputFieldPicker(pickItems: Currency.all)
    private let paymentTypePicker = InputFieldPicker(pickItems: PaymentType.all)
    
    private let storage = PaymentMethodStorage()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputFields()
        
        addMethodBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in self.addPaymentMethod() })
            .disposed(by: disposeBag)
    }
    
    private func setupInputFields() {
        bankInput.inputView = bankPicker
        bankInput.inputAccessoryView = UIUtils.nextBtnToolbar(nextResponder: currencyInput, style: .default)
        currencyInput.inputView = currencyPicker
        currencyInput.inputAccessoryView = UIUtils.nextBtnToolbar(nextResponder: typeInput, style: .default)
        typeInput.inputView = paymentTypePicker
        typeInput.inputAccessoryView = UIUtils.doneBtnToolbar(responder: typeInput, style: .default)
        
        bankPicker.rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.bankInput.text = self.bankPicker.selectedItem.title
            })
            .disposed(by: disposeBag)
        
        currencyPicker.rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.currencyInput.text = self.currencyPicker.selectedItem.title
            })
            .disposed(by: disposeBag)
        
        paymentTypePicker.rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.typeInput.text = self.paymentTypePicker.selectedItem.title
            })
            .disposed(by: disposeBag)
    }
    
    private func addPaymentMethod() {
        print("ADD PAYMENT METHOD AND COMPLETE")
        let method = PaymentMethod(bankPicker.selectedItem, paymentTypePicker.selectedItem, currencyPicker.selectedItem)
        storage.add(newMethod: method)
        
        view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
}
