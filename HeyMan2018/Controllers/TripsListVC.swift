//
//  TripsListVC.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import UIKit

private let mockData: [Trip] = [
    Trip("Trip 1", Date(), Money(100.0, .usd)),
    Trip("Trip 1", Date(), Money(100.0, .usd)),
    Trip("Trip 1", Date(), Money(100.0, .usd))
]

class TripsListVC: UIViewController {
    
    @IBOutlet weak var tripsTable: UITableView!
    
    private var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripsTable.dataSource = self
        
        loadTrips()
    }
    
    private func loadTrips() {
        trips = mockData
        tripsTable.reloadData()
    }
}

extension TripsListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trip = trips[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
        
        cell.title.text = trip.title
        cell.subtitle.text = trip.formattedDate
        cell.totalFee.text = trip.totalFee.formatted
        
        return cell
    }
}

class TripCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var totalFee: UILabel!
    
}
