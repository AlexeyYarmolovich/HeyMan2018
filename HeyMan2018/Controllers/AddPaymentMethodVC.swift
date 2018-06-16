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
        currencyInput.inputView = currencyPicker
        typeInput.inputView = paymentTypePicker
    }
    
    private func addPaymentMethod() {
        print("ADD PAYMENT METHOD AND COMPLETE")
        let method = PaymentMethod(bankPicker.selectedItem, paymentTypePicker.selectedItem, currencyPicker.selectedItem)
        view.endEditing(true)
    }
}

protocol TitleRepresentable {
    var title: String { get }
}

class InputFieldPicker<T: TitleRepresentable>: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickItems = [T]()
    var selectedItem: T {
        return pickItems[selectedRow(inComponent: 0)]
    }
    
    convenience init(pickItems: [T]) {
        self.init()
        self.delegate = self
        self.dataSource = self
        self.pickItems = pickItems
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickItems[row].title
    }
}
