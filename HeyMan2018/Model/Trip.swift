//
//  Trip.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import SwiftyJSON

enum TripType: Int {
    case car, flight
}

struct Trip: JSONParsable, JSONConvertable {
    var id: Double
    var title: String
    var endDate: Date
    var totalFee: Money?
    var type: TripType
    
    init(_ title: String, _ endDate: Date, _ totalFee: Money, _ type: TripType) {
        self.id = Date().timeIntervalSinceNow
        self.title = title
        self.endDate = endDate
        self.totalFee = totalFee
        self.type = type
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/YYYY"
        return formatter.string(from: endDate)
    }
    
    init?(json: JSON) {
        id = json["id"].doubleValue
        title = json["title"].stringValue
        endDate = Date(timeIntervalSince1970: json["endDate"].doubleValue)
        totalFee = Money(json: json["totalFee"])
        type = TripType(rawValue: json["type"].intValue) ?? .car
    }
    
    func toJSON() -> [String: Any] {
        let dict: [String: Any] = [
            "id" : id,
            "title" : title,
            "endDate" : endDate.timeIntervalSinceNow,
            "totalFee" : totalFee?.toJSON() ?? [],
            "type" : type.rawValue
        ]
        return dict
    }
}
