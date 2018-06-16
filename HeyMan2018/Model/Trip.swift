//
//  Trip.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import SwiftyJSON

struct Trip: JSONParsable, JSONConvertable {
    var title: String
    var endDate: Date
    var totalFee: Money?
    
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
    
    init?(json: JSON) {
        title = json["title"].stringValue
        endDate = Date(timeIntervalSince1970: json["endDate"].doubleValue)
        totalFee = Money(json: json["totalFee"])
    }
    
    func toJSON() -> [String: Any] {
        let dict: [String: Any] = [
            "title" : title,
            "endDate" : endDate.timeIntervalSinceNow,
            "totalFee" : totalFee?.toJSON() ?? []
        ]
        return dict
    }
}
