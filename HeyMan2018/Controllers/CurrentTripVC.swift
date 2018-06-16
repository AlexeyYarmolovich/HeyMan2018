//
//  CurrentTripVC.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import UIKit

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
    
    private var quickTasksTransition = Transition()
//    var primeGestureRecognizer: UIPanGestureRecognizer {
//        return quickTasksTransition.enterPanRecognizer
//    }
    
    private var items = [TripItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTable.dataSource = self
        
        quickTasksTransition.sourceViewController = self
//        self.swipeGestureRecognizer.require(toFail: primeGestureRecognizer)
        
        loadItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        segue.destination.transitioningDelegate = quickTasksTransition
        quickTasksTransition.destinationViewController = segue.destination
    }
    
    private func loadItems() {
        items = mockData
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
        cell.price.text = item.price?.formatted
        cell.fee.text = item.fee?.formatted
        
        return cell
    }
}

class TripItemCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var fee: UILabel!
    
}
