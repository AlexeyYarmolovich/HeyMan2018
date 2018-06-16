//
//  Animator.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import UIKit

extension UIViewControllerContextTransitioning {
    var views: (from: UIView, to: UIView) {
        let fromVC = self.viewController(forKey: .from)!
        let fromView = self.view(forKey: .from) ?? fromVC.view
        
        let toVC = self.viewController(forKey: .to)!
        let toView = self.view(forKey: .to) ?? toVC.view
        
        return (from: fromView!, to: toView!)
    }
    
    var controllers: (from: UIViewController?, to: UIViewController?) {
        let fromVC = self.viewController(forKey: .from)
        let toVC = self.viewController(forKey: .to)
        
        return (from: fromVC, to: toVC)
    }
}

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .white
        
        return indicator
    }()
    var direction: TransitionDirection
    
    init(direction: TransitionDirection) {
        self.direction = direction
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let views = transitionContext.views
        transform(transitionContext, transitionContext.containerView, views.from, views.to)
    }
    
    // swiftlint:disable:next variable_name
    func transform(_ context: UIViewControllerContextTransitioning, _ container: UIView, _ from: UIView, _ to: UIView) {
        indicator.startAnimating()
        
        let duration = self.transitionDuration(using: context)
        let width = container.frame.width
        var translate = (from: CGAffineTransform.identity, to: CGAffineTransform.identity)
        
        let initialTransition = {
            translate.from.tx = 2 / 3 * width * CGFloat(self.direction.multiplier)
            translate.to.tx = 2 / 3 * width * CGFloat(self.direction.inverse.multiplier)
            
            from.transform = translate.from
            to.transform = translate.to
        }
        to.transform = CGAffineTransform(translationX: CGFloat(direction.inverse.multiplier) * width, y: 0)
        
        indicator.center = CGPoint(x: container.bounds.width / 2, y: container.bounds.height / 2)
        container.backgroundColor = from.backgroundColor
        container.addSubview(indicator)
        container.addSubview(from)
        container.addSubview(to)
        
        UIView.animate(withDuration: duration / 2, animations: initialTransition, completion: { _ in
            if context.transitionWasCancelled {
                container.superview?.addSubview(from)
                context.completeTransition(false)
            } else {
                UIView.animate(withDuration: duration / 2, delay: 0.1, options: [], animations: {
                    translate.from.tx = width * CGFloat(self.direction.multiplier)
                    from.transform = translate.from
                    to.transform = .identity
                }, completion: { _ in
                    container.superview?.addSubview(to)
                    context.completeTransition(!context.transitionWasCancelled)
                })
            }
        })
    }
}

enum TransitionDirection: String {
    case straight, reverse
    
    var inverse: TransitionDirection {
        switch self {
        case .straight: return .reverse
        case .reverse: return .straight
        }
    }
    
    var multiplier: Int {
        switch self {
        case .straight: return 1
        case .reverse: return -1
        }
    }
    
    mutating func revert() {
        self = self.inverse
    }
}

