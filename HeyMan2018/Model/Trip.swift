//
//  Trip.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation

struct Trip {
    var title: String
    var endDate: Date
    var totalFee: Money
    
    init(_ title: String, _ endDate: Date, _ totalFee: Money) {
        self.title = title
        self.endDate = endDate
        self.totalFee = totalFee
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/YYYY"
        return formatter.string(from: endDate)
    }
}
