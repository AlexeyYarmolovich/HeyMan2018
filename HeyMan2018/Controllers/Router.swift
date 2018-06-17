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
    
    var createTripVC: UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTripVC")
    }
    
    var currentTripVC: UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrentTripVC")
    }
    
    var cameraVC: UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraVC")
    }
    
    func initialize() {
        if UserStorage.shared.launchedBefore() {
            keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
        } else {
            keyWindow?.rootViewController = createTripVC
            UserStorage.shared.set(launchedBefore: true)
        }
    }
    
    func navigateToMain() {
        keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
    }
    
    func showAddCard() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPaymentMethodVC")
        keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
    }
}
