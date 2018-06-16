//
//  PaymentMethodStorage.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

private let storageKey = "PaymentMethods"

class PaymentMethodStorage {
    
    lazy var paymentMethods: Variable<[PaymentMethod]> = {
        return Variable<[PaymentMethod]>(self.load())
    }()
    
    var hasNoPaymentMethods: Bool {
        return paymentMethods.value.isEmpty
    }
    
    private lazy var storage: SimpleKeyStorage = {
        return SimpleKeyStorage<NSData>(name: storageKey)
    }()
    
    static func clearAll() {
        SimpleKeyStorage<NSData>(name: storageKey).clearAll()
    }
    
    public func add(newMethod method: PaymentMethod) {
        paymentMethods.value.append(method)
        save(paymentMethods.value)
    }
    
    private func save(_ methods: [PaymentMethod]) {
        let json = JSON(methods.map { JSON($0.toJSON()) })
        do {
            let jsonData = try json.rawData() as NSData
            storage.save(object: jsonData, forKey: "payment_methods")
        } catch {
            print("Can not serialize JSON into Data")
        }
    }
    
    private func load() -> [PaymentMethod] {
        guard let jsonData = storage.object(forKey: "payment_methods") as Data? else { return [] }
        guard let json = try? JSON(data: jsonData) else { return [] }
        let guests = json.arrayValue.map { PaymentMethod(json: $0) }.filter { $0 != nil }.map { $0! }
        return guests
    }
}
