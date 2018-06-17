//
//  UserStorage.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation

class UserStorage {
    
    static let shared = UserStorage()
    
    init() {
        UserDefaults.standard.synchronize()
    }
    
    func launchedBefore() -> Bool {
        return UserDefaults.standard.bool(forKey: "launchedBefore")
    }
    
    func set(launchedBefore: Bool) {
        UserDefaults.standard.set(launchedBefore, forKey: "launchedBefore")
    }
    
    func lastTotal() -> Double {
        return UserDefaults.standard.double(forKey: "lastTotal")
    }
    
    func set(lastTotal: Double) {
        UserDefaults.standard.set(lastTotal, forKey: "lastTotal")
    }
}
