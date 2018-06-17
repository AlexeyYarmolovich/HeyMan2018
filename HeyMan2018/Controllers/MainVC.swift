//
//  MainVC.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 16.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation

class MainVC: UIPageViewController {
    
     lazy var pages: [UIViewController] = {
        return [
            Router.shared.cameraVC,
            Router.shared.currentTripVC
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let firstVC = pages.last {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.backgroundColor = UIColor.main
            }
        }
    }
}

extension MainVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
}
