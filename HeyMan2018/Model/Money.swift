//
//  Money.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import SwiftyJSON

struct Money: JSONParsable, JSONConvertable {
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
        }
    }
    
    init?(json: JSON) {
        value = json["value"].doubleValue
        currency = Currency(rawValue: json["currency"].stringValue) ?? .usd
    }
    
    func toJSON() -> [String: Any] {
        let dict: [String: Any] = [
            "value" : value,
            "currency" : currency.rawValue
        ]
        return dict
    }
}
