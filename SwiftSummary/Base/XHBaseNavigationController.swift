//
//  XHBaseNavigationController.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/5.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

typealias UIViewControllerAnimationBlock = (_ operation: UINavigationController.Operation, _ fromVC: UIViewController, _ toVC: UIViewController) -> UIViewControllerAnimatedTransitioning

class XHBaseNavigationController: UINavigationController {
    
    var animationBlock : UIViewControllerAnimationBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleColor               = UIColor.black
        self.titleFont                = UIFont.Semibold(17)
        
        self.view.backgroundColor = UIColor.white;
        
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = self
            self.delegate = self
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) && animated == true {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) && animated == true {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        return super.popToRootViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) && animated == true {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        return super.popToViewController(viewController, animated: animated)
    }
}


extension XHBaseNavigationController : UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    // Mark - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.isEnabled = viewController.closePopGestureRecognizer ? false : true
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if self.animationBlock != nil {
            return self.animationBlock!(operation, fromVC, toVC)
        }
        
        return nil
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0] {
                return false
            }
        }
        
        return true
    }
}
