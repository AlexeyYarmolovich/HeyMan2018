//
//  Router.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation

public let keyWindow = UIApplication.shared.keyWindow

class Router {
    
    static let shared = Router()
    
    func initialize() {
        if UserStorage.shared.launchedBefore() {
            keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrentTripVC")
        } else {
            keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTripVC")
            UserStorage.shared.set(launchedBefore: true)
        }
    }
    
    func navigateToMain() {
        keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrentTripVC")
    }
}
