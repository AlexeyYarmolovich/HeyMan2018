//
//  PaymentMethod.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation

struct PaymentMethod {
    var bank: Bank
    var type: PaymentType
    var currency: Currency
    
    init(_ bank: Bank, _ type: PaymentType, _ currency: Currency) {
        self.bank = bank
        self.type = type
        self.currency = currency
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
