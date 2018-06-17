//
//  ProgressImageView.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 17.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation

class ProgressImageView: UIImageView {
    
    private let arcLayer = CAShapeLayer()
    
    var lineWidth: CGFloat = 4
    var ratio: CGFloat = 0.0 {
        didSet {
            configLayer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        arcLayer.frame = bounds
        
        configLayer()
    }
    
    private func initLayer() {
//        arcLayer.strokeColor = UIColor(red: 255/255, green: 170/255, blue: 8/255, alpha: 1).cgColor
        arcLayer.strokeColor = #colorLiteral(red: 0.2942936718, green: 0.7115462422, blue: 0.2344135344, alpha: 1).cgColor
        
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.lineWidth = lineWidth
        arcLayer.frame = bounds
        
        layer.addSublayer(arcLayer)
        layer.cornerRadius = frame.width / 2
        
        image = UIImage(named: "avatar")
        contentMode = .scaleAspectFill
        
        configLayer()
    }
    
    private func configLayer() {
        arcLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.width / 2), radius: frame.width / 2 , startAngle: -CGFloat(Double.pi / 2), endAngle: ratio * CGFloat(Double.pi) * 3 / 2 - CGFloat(Double.pi / 2), clockwise: true).cgPath
    }
}
