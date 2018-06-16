//
//  ItemStorage.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import RxSwift
import SwiftyJSON

private let storageKey = "Items"

class ItemStorage {
    
    lazy var items: Variable<[TripItem]> = {
        return Variable<[TripItem]>(self.load())
    }()
    
    var hasNoItems: Bool {
        return items.value.isEmpty
    }
    
    private lazy var storage: SimpleKeyStorage = {
        return SimpleKeyStorage<NSData>(name: storageKey)
    }()
    
    private let tripId: String
    
    init(tripId: String) {
        self.tripId = tripId
    }
    
    static func clearAll() {
        SimpleKeyStorage<NSData>(name: storageKey).clearAll()
    }
    
    public func add(newItem item: TripItem) {
        items.value.append(item)
        save(items.value)
    }
    
    private func save(_ methods: [TripItem]) {
        let json = JSON(methods.map { JSON($0.toJSON()) })
        do {
            let jsonData = try json.rawData() as NSData
            storage.save(object: jsonData, forKey: tripId)
        } catch {
            print("Can not serialize JSON into Data")
        }
    }
    
    private func load() -> [TripItem] {
        guard let jsonData = storage.object(forKey: tripId) as Data? else { return [] }
        guard let json = try? JSON(data: jsonData) else { return [] }
        let guests = json.arrayValue.map { TripItem(json: $0) }.filter { $0 != nil }.map { $0! }
        return guests
    }
}
