//
//  InputFieldPicker.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import UIKit

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
