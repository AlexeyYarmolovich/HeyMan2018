//
//  PaymentMethod.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONParsable {
    init?(json: JSON)
}

extension JSONParsable {
    static func parse(fromJson json: JSON?) -> Self? {
        guard let json = json else { return nil }
        return self.init(json: json)
    }
}

protocol JSONConvertable {
    func toJSON() -> [String: Any]
}

struct PaymentMethod: JSONParsable, JSONConvertable {
    var bank: Bank
    var type: PaymentType
    var currency: Currency
    
    init(_ bank: Bank, _ type: PaymentType, _ currency: Currency) {
        self.bank = bank
        self.type = type
        self.currency = currency
    }
    
    init?(json: JSON) {
        bank = Bank(rawValue: json["bank"].stringValue) ?? .mtb
        type = PaymentType(rawValue: json["type"].stringValue) ?? .visa
        currency = Currency(rawValue: json["currency"].stringValue) ?? .usd
    }
    
    func toJSON() -> [String: Any] {
        let dict: [String: Any] = [
            "bank" : bank.rawValue,
            "type" : type.rawValue,
            "currency" : currency.rawValue
        ]
        return dict
    }
}

enum Bank: String, TitleRepresentable {
    case mtb = "МТБ Банк"
    case belarus = "Беларусбанк"
    case vtb = "ВТБ Банк"
    case alpha = "Альфа-Банк"
    
    static var all: [Bank] {
        return [.mtb, .belarus, .vtb, .alpha]
    }
    
    var title: String {
        return self.rawValue
    }
}

enum PaymentType: String, TitleRepresentable {
    case visa = "VISA", master = "MasterCard", union = "UnionPay"
    
    static var all: [PaymentType] {
        return [.visa, .master, .union]
    }
    
    var title: String {
        return self.rawValue
    }
}
