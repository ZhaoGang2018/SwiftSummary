//
//  UIViewController+Extension.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/5.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

enum UINavigationBarButtonType {
    case left
    case right
}

private var XHTapToDismissKeyBoardKey:String = "XHTapToDismissKeyBoardKey"
var closePopGestureRecognizerKey = "closePopGestureRecognizer"

extension UIViewController {
    
    var closePopGestureRecognizer: Bool {
        set {
            objc_setAssociatedObject(self, &closePopGestureRecognizerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &closePopGestureRecognizerKey) as? Bool {
                return rs
            }
            return false
        }
    }
    
    var currentNavigationBar: UINavigationBar? {
        
        var bar : UINavigationBar?
        
        if self.isKind(of: UINavigationController.self) {
            let navController = self as! UINavigationController
            bar = navController.navigationBar
        } else {
            bar = self.navigationController?.navigationBar
        }
        
        return bar
    }
    
    var titleColor : UIColor? {
        set {
            var attributes = self.currentNavigationBar?.titleTextAttributes
            if attributes == nil {
                attributes = [NSAttributedString.Key.foregroundColor : newValue!]
            } else {
                attributes![NSAttributedString.Key.foregroundColor] = newValue!
            }
            
            self.currentNavigationBar?.titleTextAttributes = attributes
        }
        
        get {
            return nil
        }
    }
    
    var titleFont : UIFont? {
        set {
            var attributes = self.currentNavigationBar?.titleTextAttributes
            if attributes == nil {
                attributes = [NSAttributedString.Key.font : newValue!]
            } else {
                attributes![NSAttributedString.Key.font] = newValue
            }
            
            self.currentNavigationBar?.titleTextAttributes = attributes
        }
        
        get {
            return nil
        }
    }
    
    var isTapAnywhereToDismissKeyBoard:Bool?{
        get{
            return objc_getAssociatedObject(self, &XHTapToDismissKeyBoardKey) as? Bool
        }
        
        set{
            objc_setAssociatedObject(self, &XHTapToDismissKeyBoardKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            if newValue == false{return}
            setupTapAnywhereToDismissKeyBoard()
        }
    }
    
    ///Mark - 点击屏幕收起键盘
    private func setupTapAnywhereToDismissKeyBoard(){
        
        let notiCenter = NotificationCenter.default
        let mainQuene = OperationQueue.main
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapToDismissKeyboard))
        tapGes.delegate = self as? UIGestureRecognizerDelegate
        notiCenter.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: mainQuene) {[weak self] (noti) in
            self?.view?.removeGestureRecognizer(tapGes)
        }
        
        notiCenter.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: mainQuene) { [weak self](noti) in
            self?.view.addGestureRecognizer(tapGes)
        }
    }
    
    @objc private func tapToDismissKeyboard(){
        view.endEditing(true)
    }

}


// MARK: -  处理界面跳转
extension UIViewController {
    
    // MARK: - 通过UIStoryboard创建UIViewController
    
    /// 通过UIStoryboard创建UIViewController
    /// - Parameters:
    ///   - storyboardName: UIStoryboard的名字
    ///   - classType: VC的类名
    ///   - identifier: 唯一标识，默认和类名一样，如果不一样需要在外面设置
    /// - Returns: 返回VC
    class func buildViewController<T: UIViewController>(storyboardName: String, classType: T.Type, identifier: String = T.nameOfClass) -> T? {
        
        if identifier.count == 0 {
            return nil
        }
        
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: identifier) as? T
        return vc
    }
    
    // MARK: - 向前跳转方法
    func pushOrPresentViewController(_ viewController: UIViewController, animated: Bool = true) {
        
        if let nav = self.navigationController {
            nav.pushViewController(viewController, animated: animated)
        } else {
//            viewController.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .left) , dismissing: .uncover(direction: .right))
//            viewController.hero.isEnabled = true
            self.present(viewController, animated: animated, completion: nil)
        }
    }
    
    // MARK: - 向后返回方法
    func popOrDismissViewController(animated: Bool = true) {
        
        if let nav = self.navigationController {
            if nav.viewControllers.count == 1 && nav.viewControllers.first == self, nav.presentingViewController != nil {
                nav.dismiss(animated: true, completion: nil)
            } else {
                nav.popViewController(animated: animated)
            }
        } else {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    // MARK: - 返回到指定的vc
    func popToSpecifiedViewController(specifiedVC: UIViewController.Type) -> Bool {
        var isSuccess = false
        if let nav = self.navigationController {
            for vc in nav.viewControllers {
                if vc.isMember(of: specifiedVC) {
                    nav.popToViewController(vc, animated: true)
                    isSuccess = true
                    break
                }
            }
        }
        return isSuccess
    }
    
    ///  返回到指定的VC
    /// - Parameter vcClass: UIViewController的实例，不能是UIViewController的子类
    /// - Returns: 是否成功
    /// - 调用该方法的实例必须是UIViewController的实例，不能是UIViewController的子类
    func returnToViewController(_ vcClass: UIViewController.Type) -> Bool {
        
        // 就在当前界面
        if self.isMember(of: vcClass) {
            return true
        }
        
        // 情况1、存在navigationController
        var jumpVC: UIViewController?
        var jumpNav: UINavigationController?
        if let nav = self.navigationController {
            for tempVC in nav.viewControllers {
                if tempVC.isMember(of: vcClass) {
                    jumpVC = tempVC
                    jumpNav = nav
                    break
                }
            }
        }
        
        if let finnalVC = jumpVC, let finalNav = jumpNav {
            finalNav.popToViewController(finnalVC, animated: true)
            return true
        }
        
        // 情况2、存在tabBarController,这种情况在团队主页相关界面出现
        if let tabBarC = self.tabBarController, let nav = tabBarC.navigationController {
            for tempVC in nav.viewControllers {
                if tempVC.isMember(of: vcClass) {
                    jumpVC = tempVC
                    jumpNav = nav
                    break
                }
            }
        }
        
        if let finnalVC = jumpVC, let finalNav = jumpNav {
            finalNav.popToViewController(finnalVC, animated: true)
            return true
        }
        
        // 情况3、模态跳转出的界面，这种情况比较复杂
        var modalVCs: [UIViewController] = [] // 所有的presentingViewController，可能是VC，也可能是NavigationController
        
        var presentingVC = self
        while let tempVC = presentingVC.presentingViewController {
            modalVCs.append(tempVC)
            presentingVC = tempVC
        }
        
        for modalVC in modalVCs {
            if let nav = modalVC as? UINavigationController {
                for tempVC1 in nav.viewControllers {
                    if tempVC1.isMember(of: vcClass) {
                        jumpVC = tempVC1
                        jumpNav = nav
                        break
                    }
                }
                
                for tempVC2 in nav.tabBarController?.navigationController?.viewControllers ?? [] {
                    if tempVC2.isMember(of: vcClass) {
                        jumpVC = tempVC2
                        jumpNav = nav.tabBarController?.navigationController
                        break
                    }
                }
            } else {
                if modalVC.isMember(of: vcClass) {
                    jumpVC = modalVC
                    break
                }
            }
        }
        
        if let finnalVC = jumpVC {
            presentingVC.dismiss(animated: true) {
                jumpNav?.popToViewController(finnalVC, animated: true)
            }
            return true
        }
        
        return false
    }
    
    // MARK: - 从导航栈中移除指定类型的VC
    func removeViewControllerFromNavigation(_ vcClass: UIViewController.Type) {
        
        if let nav = self.navigationController {
            let originVCs = nav.viewControllers
            var newVCs:[UIViewController] = []
            for tempVC in originVCs {
                if !tempVC.isKind(of: vcClass) {
                    newVCs.append(tempVC)
                }
            }
            nav.viewControllers = newVCs
        }
    }
    
    func removeViewControllersFromNavigation(_ vcClasses: [UIViewController.Type]) {
        
        if let nav = self.navigationController {
            let originVCs = nav.viewControllers
            var newVCs:[UIViewController] = []
            for tempVC in originVCs {
                var isContain = false
                
                for classType in vcClasses {
                    if tempVC.isKind(of: classType) {
                        isContain = true
                        break
                    }
                }
                
                if isContain == false {
                    newVCs.append(tempVC)
                }
            }
            nav.viewControllers = newVCs
        }
    }
    
}

/*
 class func jumpToViewController(_ vcClass: UIViewController.Type,currentController:UIViewController?) {
     
     var cur = currentController
     
     while cur?.presentedViewController != nil{
         
         if cur?.isMember(of: vcClass) == true{
             return
         }
         
         cur?.dismiss(animated: false, completion: nil)
         cur = cur?.presentedViewController
     }
     
     if let nav = cur?.navigationController{
         
        let vc = nav.childViewControllers.first{$0.isMember(of: vcClass) == true}
         if vc != nil{
             nav.popToViewController(vc!, animated: false)
         }else{
             nav.popToRootViewController(animated: false)
         }
         jumpToViewController(vcClass, currentController: nav)
         return
     }
     
     if let tabbar = cur?.tabBarController{
         
         for (index,child) in tabbar.childViewControllers.enumerated(){
             
             if let nav = child as? UINavigationController{
                 let vc = nav.childViewControllers.first{$0.isMember(of: vcClass) == true}
                 if vc != nil{
                     nav.popToViewController(vc!, animated: false)
                     tabbar.selectedIndex = index
                     return
                 }
             }else if child.isMember(of: vcClass){
                 tabbar.selectedIndex = index
                 return
             }
         }
         
         //到此tabbar内也没有
         jumpToViewController(vcClass, currentController: tabbar)
         return
     }
     
     print(currentController.debugDescription)
 }

 */

