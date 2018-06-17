//
//  TripsStorage.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import RxSwift
import SwiftyJSON

private let storageKey = "Items"

class TripsStorage {
  
  static let shared = TripsStorage()
  
  var lastTrip: Trip? {
    return trips.value.last
  }
    
    lazy var trips: Variable<[Trip]> = {
        return Variable<[Trip]>(self.load())
    }()
    
    var hasNoTrips: Bool {
        return trips.value.isEmpty
    }
    
    private lazy var storage: SimpleKeyStorage = {
        return SimpleKeyStorage<NSData>(name: storageKey)
    }()
    
    static func clearAll() {
        SimpleKeyStorage<NSData>(name: storageKey).clearAll()
    }
    
    public func add(newTrip trip: Trip) {
        trips.value.append(trip)
        save(trips.value)
    }
    
    private func save(_ methods: [Trip]) {
        let json = JSON(methods.map { JSON($0.toJSON()) })
        do {
            let jsonData = try json.rawData() as NSData
            storage.save(object: jsonData, forKey: "trips")
        } catch {
            print("Can not serialize JSON into Data")
        }
    }
    
    private func load() -> [Trip] {
        guard let jsonData = storage.object(forKey: "trips") as Data? else { return [] }
        guard let json = try? JSON(data: jsonData) else { return [] }
        let guests = json.arrayValue.map { Trip(json: $0) }.filter { $0 != nil }.map { $0! }
        return guests
    }
}
