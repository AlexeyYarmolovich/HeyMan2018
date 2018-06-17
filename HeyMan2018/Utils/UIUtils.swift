//
//  UIUtils.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 17.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//


class UIUtils {
    static func nextBtnToolbar<T: UIResponder>(nextResponder: T, style: UIBarStyle = .default) -> UIToolbar {
        return actionToolbar(title: "NEXT",
                             style: style,
                             target: nextResponder,
                             action: #selector(T.becomeFirstResponder))
    }
    
    static func doneBtnToolbar<T: UIResponder>(responder: T, style: UIBarStyle = .default) -> UIToolbar {
        return actionToolbar(title: "DONE",
                             style: style,
                             target: responder,
                             action: #selector(T.resignFirstResponder))
    }
    
    static func actionToolbar(title: String, style: UIBarStyle = .default, target: Any, action: Selector) -> UIToolbar {
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = style
        
        let actionButton = UIBarButtonItem(title: title, style: .done, target: target, action: action)
        
        numberToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            actionButton
        ]
        numberToolbar.sizeToFit()
        
        return numberToolbar
    }
}
