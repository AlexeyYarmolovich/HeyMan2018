//
//  CGRectExt.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 17.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import UIKit

extension CGRect {
    func copyWith(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> CGRect {
        let x = x ?? origin.x
        let y = y ?? origin.y
        let width = width ?? self.width
        let height = height ?? self.height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
