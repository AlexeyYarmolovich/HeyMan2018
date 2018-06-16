//
//  SimpleKeyStorage.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation
import AwesomeCache

protocol KeyValueStorage {
    associatedtype Element
    func save(object: Element, forKey key: String)
    func remove(byKey key: String)
    func object(forKey key: String) -> Element?
    
    func clearAll()
}

class SimpleKeyStorage<E: AnyObject>: KeyValueStorage where E: NSCoding {
    typealias Element = E
    let storage: Cache<Element>
    
    var name: String {
        return storage.name
    }
    
    init() {
        storage = try! Cache(name: "storage")
    }
    
    init(name: String) {
        storage = try! Cache(name: name)
    }
    
    func save(object: Element, forKey key: String) {
        storage.setObject(object, forKey: key)
    }
    
    func remove(byKey key: String) {
        storage.removeObject(forKey: key)
    }
    
    func object(forKey key: String) -> Element? {
        return storage.object(forKey: key, returnExpiredObjectIfPresent: false)
    }
    
    func clearAll() {
        storage.removeAllObjects()
    }
}
