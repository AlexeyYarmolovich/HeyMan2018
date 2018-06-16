//
//  Transition.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

//
//  TransitionManager.swift
//  Transitions
//
//  Created by Artsiom Grintsevich on 12/18/15.
//  Copyright © 2015 Artsiom Grintsevich. All rights reserved.
//

import UIKit

class Transition: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate {
    
    var interactive = false
    
    var enterPanRecognizer: UIScreenEdgePanGestureRecognizer!
    var exitPanRecognizer: UIScreenEdgePanGestureRecognizer!
    
    let animator = TransitionAnimator(direction: .straight)
    
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanRecognizer = UIScreenEdgePanGestureRecognizer()
            self.enterPanRecognizer.addTarget(self, action: #selector(onStartGestureHandling(_:)))
            self.enterPanRecognizer.edges = .left
            self.sourceViewController.view.addGestureRecognizer(self.enterPanRecognizer)
        }
    }
    
    var destinationViewController: UIViewController! {
        didSet {
            self.exitPanRecognizer = UIScreenEdgePanGestureRecognizer()
            self.exitPanRecognizer.addTarget(self, action: #selector(onDismissGestureHandling(_:)))
            self.exitPanRecognizer.edges = .right
            self.destinationViewController.view.addGestureRecognizer(self.exitPanRecognizer)
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        self.animator.direction = .straight
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        self.animator.direction = .reverse
        return self.interactive ? self : nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.direction = .reverse
        return animator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.direction = .straight
        return animator
    }
    
    @objc private func onStartGestureHandling(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!)
        let delta = translation.x / sender.view!.bounds.width * 0.5
        
        switch sender.state {
        case .began:
            interactive = true
            sourceViewController.performSegue(withIdentifier: "ScannerSegue", sender: self)
        case .changed:
            self.update(delta)
        default:
            interactive = false
            if delta > 0.2 {
                self.finish()
            } else {
                self.cancel()
            }
        }
    }
    
    @objc private func onDismissGestureHandling(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!)
        let delta = -translation.x / sender.view!.bounds.width * 0.5
        
        switch sender.state {
        case .began:
            interactive = true
            destinationViewController.dismiss(animated: true, completion: nil)
        case .changed:
            self.update(delta)
        case .cancelled, .ended:
            interactive = false
            if delta > 0.2 {
                self.finish()
            } else {
                self.cancel()
            }
        default: return
        }
    }
}

