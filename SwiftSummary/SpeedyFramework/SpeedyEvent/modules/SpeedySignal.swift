//
//  SpeedySignal.swift
//  XCamera
//
//  Created by 赵刚 on 2020/2/28.
//  Copyright © 2020 xhey. All rights reserved.
//

/*
 * 使用方法：
 * 1、如果是UIView发送的信号量，则与它相关的superview，UIViewController会接到信号，
 * 与这个view的VC相关的VC不会接到信号。
 * 2、如果是VC发送的信号量，则navigation中的所有VC都能接到信号。
 */

import UIKit

// MARK: - 信号量的model
class SpeedySignal: NSObject {
    
    var from: AnyObject?
    var name: String?
    var toClass: AnyClass?
    var parameter: Any? // 参数
    var tag: Int = 0
    
    convenience init(from: AnyObject?, name: String?, toClass: AnyClass? = nil, parameter: Any? = nil, tag: Int = 0) {
        self.init()
        self.from = from
        self.name = name
        self.toClass = toClass
        self.parameter = parameter
        self.tag = tag
    }
    
    func isEqualToName(other: String) -> Bool {
        return self.name == other
    }
    
    func isFromClass<T>(aClass: T.Type) -> Bool {
        if (self.from as? T) != nil {
            return true
        }
        return false
    }
}

// MARK: - SpeedySignalProtocol
protocol SpeedySignalProtocol {
    func handleUISignal(_ signal:SpeedySignal)
    func handleNavigationSignal(_ signal:SpeedySignal)
}

// 解决协议没有可选值的问题
extension SpeedySignalProtocol {
    func handleUISignal(_ signal:SpeedySignal) {}
    func handleNavigationSignal(_ signal:SpeedySignal) {}
}

extension UIResponder {
    
    func sendSignal(name: String, toClass: AnyClass? = nil, parameter: Any? = nil, tag: Int = 0) {
        let model = SpeedySignal(from: self, name: name, toClass: toClass, parameter: parameter, tag: tag)
        _ = self.send(model: model)
    }
    
    // MARK: - 发送信号量
    private func send(model: SpeedySignal) -> Bool {
        var result = true
        if let _ = model.from as? UIView {
            self.tryInvokeUI(model: model)
        } else if let _ = model.from as? UIViewController {
            self.tryInvokeNavigation(model: model)
        } else {
            result = false
        }
        return result
    }
    
    // MARK: - 尝试调用UI
    private func tryInvokeUI(model: SpeedySignal) {
        var responders: [UIResponder] = []
        if let currentView = model.from as? UIView {
            responders.append(currentView)
            var next: UIView? = currentView
            while (next != nil) {
                if let nextResponder = next?.next {
                    responders.append(nextResponder)
                }
                next = next?.superview
            }
        }
        
        if let toClass = model.toClass {
            for tempView in responders {
                if let view = tempView as? SpeedySignalProtocol, tempView.isKind(of: toClass) {
                    DispatchQueue.main.async {
                        view.handleUISignal(model)
                    }
                }
            }
        } else {
            for tempView in responders {
                if let view = tempView as? SpeedySignalProtocol {
                    DispatchQueue.main.async {
                        view.handleUISignal(model)
                    }
                }
            }
        }
    }
    
    // MARK： - 尝试调用控制器
    private func tryInvokeNavigation(model: SpeedySignal) {
        
        var VCs: [UIViewController] = []
        if let currentVC = model.from as? UIViewController {
            
            if let nav = currentVC.navigationController {
                for vc in nav.viewControllers {
                    VCs.append(vc)
                }
            }
            
            if let tabBar = currentVC.tabBarController, let tabBarVCs = tabBar.viewControllers {
                for vc in tabBarVCs {
                    if let tempNav = vc as? UINavigationController {
                        for vc2 in tempNav.viewControllers {
                            VCs.append(vc2)
                        }
                    } else {
                        VCs.append(vc)
                    }
                }
            }
            
            /*
            // 情况3、模态跳转出的界面，这种情况比较复杂
            var modalVC = currentVC.presentingViewController
            while let vc = modalVC {
                if let tempNav = vc as? UINavigationController {
                    for vc2 in tempNav.viewControllers {
                        VCs.append(vc2)
                    }
                } else {
                    VCs.append(vc)
                }
                modalVC = modalVC?.presentingViewController
            }
 */
        }
        
        var resultVCs: [UIViewController] = []
        for tempVC in VCs {
            if !resultVCs.contains(tempVC) {
                resultVCs.append(tempVC)
            }
        }
        
        if let toClass = model.toClass {
            for vc in resultVCs {
                if let tempVC = vc as? SpeedySignalProtocol, vc.isKind(of: toClass) {
                    DispatchQueue.main.async {
                        tempVC.handleNavigationSignal(model)
                    }
                }
            }
        } else {
            for vc in resultVCs {
                if let tempVC = vc as? SpeedySignalProtocol {
                    DispatchQueue.main.async {
                        tempVC.handleNavigationSignal(model)
                    }
                }
            }
        }
    }
    
}
