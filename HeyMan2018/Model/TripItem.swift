//
//  TripItem.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import SwiftyJSON

struct TripItem: JSONParsable, JSONConvertable {
    var title: String
    var price: Money?
    var fee: Money?
    
    init(_ title: String, _ price: Money, _ fee: Money) {
        self.title = title
        self.price = price
        self.fee = fee
    }
    
    init?(json: JSON) {
        title = json["title"].stringValue
        price = Money(json: json["price"])
        fee = Money(json: json["fee"])
    }
    
    func toJSON() -> [String: Any] {
        let dict: [String: Any] = [
            "title" : title,
            "price" : price?.toJSON() ?? [],
            "fee" : fee?.toJSON() ?? []
        ]
        return dict
    }
}
