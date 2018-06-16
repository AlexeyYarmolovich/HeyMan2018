//
//  Money.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation

struct Money {
    var value: Double
    var currency: Currency
    
    init(_ value: Double, _ currency: Currency) {
        self.value = value
        self.currency = currency
    }
    
    var formatted: String {
        switch currency {
        case .usd, .eur: return String(format: "%.2f\(currency)", value)
        case .byn, .rub: return String(format: "\(currency)%.2f", value)
        default: ()
        }
    }
    
    enum Currency: String {
        case usd = "$"
        case eur = "€"
        case byn = "BYN"
        case rub = "RUB"
    }
}
