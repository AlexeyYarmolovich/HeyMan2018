//
//  Currency.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation

enum Currency: String, TitleRepresentable {
    case usd = "$"
    case eur = "€"
    case byn = "BYN"
    case rub = "RUB"
    
    static var all: [Currency] {
        return [.usd, .eur, .byn, .rub]
    }
    
    var title: String {
        switch(self) {
        case .usd: return "USD"
        case .eur: return "EUR"
        case .byn: return "BYN"
        case .rub: return "RUB"
        }
    }
}
