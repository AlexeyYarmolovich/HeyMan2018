//
//  ViewController.swift
//  HeyMan2018
//
//  Created by mac-226 on 6/14/18.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateTripVC: UIViewController {

    @IBOutlet weak var carTripBtn: UIButton!
    @IBOutlet weak var flightTripBtn: UIButton!
    @IBOutlet weak var dateInputField: UITextField!
    
    private let datePicker = UIDatePicker()
    private let storage = TripsStorage()
    private let disposeBag = DisposeBag()
    
    var tripType: TripType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carTripBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.tripType = .car
                self.carTripBtn.isSelected = true
                self.flightTripBtn.isSelected = false
                self.updateButtonsBackground()
            })
            .disposed(by: disposeBag)
        
        flightTripBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.tripType = .flight
                self.flightTripBtn.isSelected = true
                self.carTripBtn.isSelected = false
                self.updateButtonsBackground()
            })
            .disposed(by: disposeBag)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        datePicker.datePickerMode = .date
        datePicker.rx.date.asDriver()
            .drive(onNext: { [unowned self] in
                self.dateInputField.text = dateFormatter.string(from: $0)
            })
            .disposed(by: disposeBag)
        
        dateInputField.inputView = datePicker
        dateInputField.inputAccessoryView = UIUtils.actionToolbar(title: "DONE", style: .default, target: self, action: #selector(navigateToTripsList))
    }
    
    private func updateButtonsBackground() {
        carTripBtn.backgroundColor = carTripBtn.isSelected ? UIColor.main.withAlphaComponent(0.3) : UIColor.clear
        flightTripBtn.backgroundColor = flightTripBtn.isSelected ? UIColor.main.withAlphaComponent(0.3) : UIColor.clear
    }
    
    @objc func navigateToTripsList() {
        let trip = Trip("", datePicker.date, Money.zero, tripType ?? .car)
        storage.add(newTrip: trip)
        Router.shared.navigateToMain()
    }
}
