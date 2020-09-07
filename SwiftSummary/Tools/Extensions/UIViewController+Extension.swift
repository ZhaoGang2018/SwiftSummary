//
//  UIViewController+Extension.swift
//  XCamera
//
//  Created by jing_mac on 2020/1/19.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation

extension UIViewController {
    
    // MARK - 跳转到团队水印界面
    func jumpToTeamWatermark() {
//        let isSuccess = self.jumpsToSpecifiedViewController(specifiedVC: PhotoEditViewController.self)
//
//        if !isSuccess {
//            if let nav = self.tabBarController?.navigationController {
//                nav.popToRootViewController(animated: true)
//            } else {
//                self.navigationController?.popToRootViewController(animated: true)
//            }
//        }
    }
    
    // MARK: - 跳转到指定的vc
    func jumpsToSpecifiedViewController(specifiedVC: UIViewController.Type) -> Bool {
//        if let _ = specifiedVC as? XHTeamMainTabBarController.Type, ((self.tabBarController as? XHTeamMainTabBarController) != nil) {
//            self.navigationController?.popToRootViewController(animated: true)
//            return true
//        }
        
        var currentNav: UINavigationController?
        var jumpVC: UIViewController?
        var isSuccess = false
        
        if let nav = self.navigationController {
            for vc in nav.viewControllers {
                if vc.isKind(of: specifiedVC) {
                    jumpVC = vc
                    currentNav = nav
                    isSuccess = true
                    break
                }
            }
        }
        
        if !isSuccess, let nav = self.tabBarController?.navigationController {
            for vc in nav.viewControllers {
                if vc.isKind(of: specifiedVC) {
                    jumpVC = vc
                    currentNav = nav
                    isSuccess = true
                    break
                }
            }
        }
        
        if let vc = jumpVC, let nav = currentNav {
            nav.popToViewController(vc, animated: true)
        }
        return isSuccess
    }
    
    // MARK: - 隐藏TabBarController中的新手引导
    func hideTabBarNewbieGuideViews() {
//        if let tabBarVC = self.tabBarController as? XHTeamMainTabBarController {
////            if tabBarVC.memberGuideView?.isHidden == false {
////                tabBarVC.setNewbieStatus(isShowedMembers: true, isShowedWorkben: false)
////            }
//
//            if tabBarVC.workbenchGuideView?.isHidden == false {
//                tabBarVC.setNewbieStatus(isShowedMembers: false, isShowedWorkben: true)
//            }
//        }
    }
    
    func showNetError(_ text: String = "当前网络不佳\n请稍后重试"){
        self.showToast(text)
    }
    
    /// 铃铛Toast提示
    func showToast(_ text: String, textStyle: HintTextStyle = .textWithImageTypeOne(image: "hint_cam_general"), animteType: HintAnimateType = .fadeInOutWithMovedAndScaleTypeOne, autoRemove: Bool = true, animateComplete: (()->())? = nil) {
        self.view.showToast(text, textStyle: textStyle, animteType: animteType, autoRemove: autoRemove, animateComplete: animateComplete)
    }
    
    /// 对号Toast提示
    func showSuccessToast(_ text: String, textStyle: HintTextStyle = .textWithImageTypeOne(image: "notification_workgroup_sync"), animteType: HintAnimateType = .fadeInOutWithMovedAndScaleTypeOne, autoRemove: Bool = true, animateComplete: (()->())? = nil) {
        
        self.view.showSuccessToast(text, textStyle: textStyle, animteType: animteType, autoRemove: autoRemove, animateComplete: animateComplete)
    }
    
    func showLoading(tipText: String = "正在加载", isShowCloseBtn: Bool = false, cancelHandler: XHLoadingCancelHandler? = nil){
        self.view.showLoading(tipText: tipText, isShowCloseBtn: isShowCloseBtn, cancelHandler: cancelHandler)
    }
    
    func hiddenLoading(){
        self.view.hiddenLoading()
    }
}

//MARK: childViewController
public extension UIViewController{
    /// 添加 a UIViewController as a childViewController.
    ///
    /// - Parameters:
    ///   - child: the view controller to add as a child
    ///   - containerView: the containerView for the child viewcontroller's root view.
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// 移除 childViewController
    func removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
