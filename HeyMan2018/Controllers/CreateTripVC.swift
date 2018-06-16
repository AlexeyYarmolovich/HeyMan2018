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
    
    private let storage = TripsStorage()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carTripBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in self.navigateToTripsList(type: .car) })
            .disposed(by: disposeBag)
        
        flightTripBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in self.navigateToTripsList(type: .flight) })
            .disposed(by: disposeBag)
    }
    
    private func navigateToTripsList(type: TripType) {
        let trip = Trip("", Date(), Money.zero, type)
        storage.add(newTrip: trip)
        Router.shared.navigateToMain()
        print("CREATE TRIP: \(type)")
    }
}
