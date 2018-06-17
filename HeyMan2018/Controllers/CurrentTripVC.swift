//
//  CurrentTripVC.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let mockData: [TripItem] = [
    TripItem("Item1", Money(10.0, .usd), Money(3.0, .eur)),
    TripItem("Item1", Money(15.0, .usd), Money(5.0, .eur)),
    TripItem("Item1", Money(110.0, .usd), Money(33.0, .eur)),
    TripItem("Item1", Money(230.0, .usd), Money(83.0, .eur)),
    TripItem("Item1", Money(120.0, .usd), Money(40.0, .eur)),
    TripItem("Item1", Money(37.0, .usd), Money(12.0, .eur))
]

class CurrentTripVC: UIViewController {
    
    @IBOutlet weak var itemTable: UITableView!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var progressImageView: ProgressImageView!
    
    private let disposeBag = DisposeBag()
    private var items = [TripItem]()
    private var totalCustoms: Double {
        let total = items.map { $0.fee?.value ?? 0.0 }
        let sum = total.reduce(0.0, +)

        return UserStorage.shared.lastTotal() + sum
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTable.dataSource = self
        itemTable.contentInset = UIEdgeInsetsMake(0, 0, 96, 0)
        
        configureBounceBackground()
        loadItems()
        
        endBtn.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                UserStorage.shared.set(lastTotal: self.totalCustoms)
                Router.shared.navigateToNewTrip()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureBounceBackground() {
        let bounceBackground = UIView(frame: itemTable.bounds.copyWith(y: -itemTable.bounds.height))
        bounceBackground.backgroundColor = UIColor.main
        bounceBackground.autoresizingMask = [.flexibleBottomMargin,
                                             .flexibleHeight,
                                             .flexibleLeftMargin,
                                             .flexibleRightMargin,
                                             .flexibleWidth,
                                             .flexibleTopMargin]
        itemTable.addSubview(bounceBackground)
    }
    
    private func loadItems() {
        items = mockData
        limitLabel.text = String(format: "€%.0f/300", totalCustoms)
        progressImageView.ratio = CGFloat(totalCustoms / 300.0)
        
        itemTable.reloadData()
    }
}

extension CurrentTripVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripItemCell", for: indexPath) as! TripItemCell
        
        cell.title.text = item.title
        cell.price.text = item.fee?.formatted
        
        return cell
    }
}

class TripItemCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    
}
