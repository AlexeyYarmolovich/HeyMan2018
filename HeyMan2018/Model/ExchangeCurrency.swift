//
//  ExchangeCurrency.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 17.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import SwiftyJSON

class ExchangeCurrency: JSONParsable, JSONConvertable {
    
    var abbr: String
    var rate: Double
    
    var currency: Currency? {
        return Currency(rawValue: abbr)
    }
    
    required init?(json: JSON) {
        abbr = json["abbreviation"].stringValue
        rate = json["rate"].doubleValue
    }
    
    func toJSON() -> [String: Any] {
        let dict: [String: Any] = [
            "abbreviation" : abbr,
            "rate" : rate
        ]
        return dict
    }
}
