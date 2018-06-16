//
//  TripItem.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation

struct TripItem {
    var title: String
    var price: Money
    var fee: Money
    
    init(_ title: String, _ price: Money, _ fee: Money) {
        self.title = title
        self.price = price
        self.fee = fee
    }
}
