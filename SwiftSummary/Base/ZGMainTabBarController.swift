//
//  ZGMainTabBarController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/1/8.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

class ZGMainTabBarController: UITabBarController {
    
    var customTabBar: ZGCustomTabBar?
    
    override var selectedIndex: Int {
        didSet {
            self.customTabBar?.selectedIndex = selectedIndex
            self.relayoutBar()
            
//            XHTimeoutTestTool.shared.pingBaiduTest(index: 0) { (error, index) in
//
//            }
        }
    }
    
    override var selectedViewController: UIViewController? {
        
        didSet {
            self.customTabBar?.selectedIndex = self.selectedIndex
            self.relayoutBar()
        }
    }
    
    deinit {
        self.tabBar.removeObserver(self, forKeyPath: "frame")
        self.tabBar.removeObserver(self, forKeyPath: "selectedItem")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customTabBar?.selectedIndex = self.selectedIndex
        self.relayoutBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.relayoutBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupChildViewControllers()
        self.buildCustomTabBar()
    }
    
    private func setupChildViewControllers() {
        
        let rankVC = ZGRankViewController()
        let audioVC = ZGAudioVideoViewController()
        let messageVC = ZGMessageViewController()
        let homePageVC = ZGHomePageViewController()
        
        self.viewControllers = [XHBaseNavigationController(rootViewController: rankVC), XHBaseNavigationController(rootViewController: audioVC), XHBaseNavigationController(rootViewController: messageVC), XHBaseNavigationController(rootViewController: homePageVC)]
    }
    
    private func buildCustomTabBar() {
        
        // 去掉系统tabBar的顶部细线(没起作用)
        let image = UIImage.imageWithColor(color: UIColor.clear, size: CGSize(width: self.tabBar.viewFrameWidth, height: self.tabBar.viewFrameHeight))
        self.tabBar.backgroundImage = image
        self.tabBar.shadowImage = image
        
        // 去掉系统tabBar的顶部细线
        self.tabBar.clipsToBounds = true
        
        customTabBar = ZGCustomTabBar()
        customTabBar?.selectedIndex = self.selectedIndex
        customTabBar?.frame = self.tabBar.frame
        customTabBar?.alpha = 1.0
        customTabBar?.backgroundColor = UIColor.white
        self.tabBar.addSubview(customTabBar!)
                
        customTabBar?.onSelect = {[weak self] selectedIndex in
            self?.selectedIndex = selectedIndex
        }
        
        self.tabBar.addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
        self.tabBar.addObserver(self, forKeyPath: "selectedItem", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        self.relayoutBar()
    }
    
    func relayoutBar() {
        if let tempView = self.customTabBar {
            self.tabBar.bringSubviewToFront(tempView)
            tempView.frame = self.tabBar.bounds
            XHLogDebug("[标签栏的frame] - [\(tempView.frame)]")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view.isKind(of: UITabBar.self) {
                view.frame = CGRect(x: 0, y: SpeedyApp.screenHeight - 49.0 - SpeedyApp.tabBarBottomHeight, width: SpeedyApp.screenWidth, height: 49.0 + SpeedyApp.tabBarBottomHeight)
            }
        }
    }
    
    
}

extension ZGMainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        XHLogDebug("选中-[\(tabBarController.selectedIndex)]")
    }
}


/*
 //
 //  XHTeamMainTabBarController.swift
 //  XCamera
 //
 //  Created by jing_mac on 2020/2/25.
 //  Copyright © 2020 xhey. All rights reserved.
 //

 import UIKit

 class XHTeamMainTabBarController: UITabBarController {
     
     var customTabBar: XHTeamCustomTabBar?
     
     // 当前工作圈的id
     var groupId : String?
     // 当前工作圈的名称
     var groupName : String?
     // groupModel
     var groupModel: SingleWorkGroupModel?
     
     var memberGuideView: XHNewbieGuideView? // 团队成员引导 isShowedTeamMembersGuideView
     var workbenchGuideView: XHNewbieGuideView? // 工作台引导 isShowedTeamWorkbenGuideView
     
     override var selectedIndex: Int {
         didSet {
             self.customTabBar?.selectedIndex = selectedIndex
             self.relayoutBar()
         }
     }
     
     override var selectedViewController: UIViewController? {
         didSet {
             self.customTabBar?.selectedIndex = self.selectedIndex
             self.relayoutBar()
         }
     }
     
     deinit {
         self.tabBar.removeObserver(self, forKeyPath: "frame")
         self.tabBar.removeObserver(self, forKeyPath: "selectedItem")
     }
     
     init(groupId: String?, groupName: String?, groupModel: SingleWorkGroupModel?) {
         self.groupId = groupId
         self.groupName = groupName
         self.groupModel = groupModel
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.customTabBar?.selectedIndex = self.selectedIndex
         self.relayoutBar()
         self.updateNewbieGuide()
     }
     
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         self.relayoutBar()
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         self.memberGuideView?.isHidden = true
         self.workbenchGuideView?.isHidden = true
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         self.delegate = self
         self.setupChildViewControllers()
         self.buildCustomTabBar()
         self.buldNewbieGuideView()
     }
     
     private func setupChildViewControllers() {
         
         let vc0 = XHTeamHomepageViewController(groupId: groupId, groupName: groupName, groupModel: groupModel)
         
         let vc1 = XHTeamMembersViewController(groupId: groupId, groupName: groupName, groupModel: groupModel)
         
         let vc2 = XHTeamWorkbenchViewController(groupId: groupId, groupName: groupName, groupModel: groupModel)
         
         let vc3 = XHManageViewController(groupId: groupId, groupName: groupName, groupModel: groupModel)
         
         self.viewControllers = [XHBaseNavigationController.buildNavigation(WithViewController: vc0),
                                 XHBaseNavigationController.buildNavigation(WithViewController: vc1),
                                 XHBaseNavigationController.buildNavigation(WithViewController: vc2),
                                 XHBaseNavigationController.buildNavigation(WithViewController: vc3)]
     }
     
     private func buildCustomTabBar() {
         
         // 去掉系统tabBar的顶部细线(没起作用)
         let image = UIImage.imageWithColor(color: UIColor.clear, size: CGSize(width: self.tabBar.width, height: self.tabBar.height))
         self.tabBar.backgroundImage = image
         self.tabBar.shadowImage = image
         
         // 去掉系统tabBar的顶部细线
         self.tabBar.clipsToBounds = true
         
         customTabBar = XHTeamCustomTabBar()
         customTabBar?.selectedIndex = self.selectedIndex
         customTabBar?.frame = self.tabBar.frame
         customTabBar?.alpha = 1.0
         self.tabBar.addSubview(customTabBar!)
         
         customTabBar?.onSelect = {[weak self] selectedIndex in
             if let weakSelf = self {
                 weakSelf.selectedIndex = selectedIndex
                 
                 if weakSelf.selectedIndex == 1 {
                     UserDefaults.standard.set(true, forKey: XHGlobalConstant.isShowedTeamMembersGuideView)
                 }
                 
                 if weakSelf.selectedIndex == 2 {
                     UserDefaults.standard.set(true, forKey: XHGlobalConstant.isShowedTeamWorkbenGuideView)
                 }
                 weakSelf.updateNewbieGuide()
             }
         }
         
         self.tabBar.addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
         self.tabBar.addObserver(self, forKeyPath: "selectedItem", options: [.new, .old], context: nil)
     }
     
     override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         self.relayoutBar()
     }
     
     func relayoutBar() {
         if let tempView = self.customTabBar {
             self.tabBar.bringSubview(toFront: tempView)
             tempView.frame = self.tabBar.bounds
         }
     }
     
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         for view in self.view.subviews {
             if view.isKind(of: UITabBar.self) {
                 view.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 49.0 - tabBarBottomHeight, width: SCREEN_WIDTH, height: 49.0 + tabBarBottomHeight)
             }
         }
     }
     
 }

 // MARK: - UITabBarControllerDelegate
 extension XHTeamMainTabBarController: UITabBarControllerDelegate {
     
     func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
         return true
     }
     
     func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         XHLogDebug("选中-[\(tabBarController.selectedIndex)]")
         
         if tabBarController.selectedIndex == 1 {
             UserDefaults.standard.set(true, forKey: XHGlobalConstant.isShowedTeamMembersGuideView)
         }
         
         if tabBarController.selectedIndex == 2 {
             UserDefaults.standard.set(true, forKey: XHGlobalConstant.isShowedTeamWorkbenGuideView)
         }
         self.updateNewbieGuide()
     }
 }

 // MARK: - 新手引导
 extension XHTeamMainTabBarController {
     // 创建新手引导
     private func buldNewbieGuideView() {
         // 团队成员引导
         let button_w: CGFloat = 60.0
         let button_h: CGFloat = 49.0
         let space_x: CGFloat = 21.0
         let margin: CGFloat = (SpeedyApp.screenWidth - space_x*3.0 - button_w*4.0)/2.0;
         
         let x1 = margin + button_w*1.5 + space_x - 168.0/2.0
         let y1 = SpeedyApp.screenHeight - SpeedyApp.tabBarBottomHeight - button_h - 46.0
         memberGuideView = XHNewbieGuideView(tipText: "查看【全部成员】", point: CGPoint(x: x1, y: y1), onSelect: { (currentView) in
             
         }, onClose: { (currentView) in
             UserDefaults.standard.set(true, forKey: XHGlobalConstant.isShowedTeamMembersGuideView)
             self.updateNewbieGuide()
         })
         UIApplication.shared.keyWindow?.addSubview(memberGuideView!)
         memberGuideView?.isHidden = true
         
         // 工作台引导
         let x2 = margin + button_w*2.5 + space_x*2.0 - 168.0/2.0
         let y2 = SpeedyApp.screenHeight - SpeedyApp.tabBarBottomHeight - button_h - 46.0
         workbenchGuideView = XHNewbieGuideView(tipText: "查看【考勤统计】", point: CGPoint(x: x2, y: y2), onSelect: { (currentView) in
             
         }, onClose: { (currentView) in
             UserDefaults.standard.set(true, forKey: XHGlobalConstant.isShowedTeamWorkbenGuideView)
             self.updateNewbieGuide()
         })
         UIApplication.shared.keyWindow?.addSubview(workbenchGuideView!)
         workbenchGuideView?.isHidden = true
     }
     
     // 更新新手引导
     private func updateNewbieGuide() {
         let isShowMembersGuide = UserDefaults.standard.bool(forKey: XHGlobalConstant.isShowedTeamMembersGuideView)
         
         let isShowWorkbenGuide = UserDefaults.standard.bool(forKey: XHGlobalConstant.isShowedTeamWorkbenGuideView)
         
         if isShowMembersGuide {
             self.memberGuideView?.isHidden = true
         } else {
             if self.workbenchGuideView?.isHidden == true {
                 self.memberGuideView?.isHidden = false
             }
         }
         
         if isShowWorkbenGuide {
             self.workbenchGuideView?.isHidden = true
         } else {
             if self.memberGuideView?.isHidden == true {
                 self.workbenchGuideView?.isHidden = false
             }
         }
     }
 }

 // MARK: - 自定义TabBar
 class XHTeamCustomTabBar: UIView {
     
     var selectedIndex: Int = 0 {
         didSet {
             for button in self.tabBarButtons {
                 button.isSelected = button.tag == self.selectedIndex
             }
         }
     }
     
     var onSelect: ((Int) -> ())?
     
     var tabBarButtons:[XHTeamCustomTabBarButton] = []
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         buildUI()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     private func buildUI() {
         self.backgroundColor = UIColor.hexString("#FAFAFA")
         
         let button_w: CGFloat = 60.0
         let button_h: CGFloat = 49.0
         let space_x: CGFloat = 21.0
         let margin: CGFloat = (SpeedyApp.screenWidth - space_x*3.0 - button_w*4.0)/2.0;
         
         let titles = ["工作圈", "团队成员", "工作台", "管理"]
         let normalImageNames = ["workgroup_tab_photoflow", "workgroup_tab_contact", "workgroup_tab_table", "workgroup_tab_setting"]
         let selectImageNames = ["workgroup_tab_photoflow_active", "workgroup_tab_contact_active", "workgroup_tab_table_active", "workgroup_tab_setting_active"]
         
         for i in 0..<4 {
             let button = XHTeamCustomTabBarButton(frame: CGRect(x: margin + (button_w + space_x)*CGFloat(i), y: 0, width: button_w, height: button_h))
             button.tag = i
             button.btnTitle = titles[i]
             
             button.setTitleColor(UIColor.hexString("#47484E"), for: .normal)
             button.setTitleColor(UIColor.hexString("#0093FF"), for: .selected)
             button.setTitleColor(UIColor.hexString("#0093FF"), for: .highlighted)
             
             button.setImage(UIImage(named: normalImageNames[i]), for: .normal)
             button.setImage(UIImage(named: selectImageNames[i]), for: .selected)
             button.setImage(UIImage(named: selectImageNames[i]), for: .highlighted)
             
             button.addTarget(self, action: #selector(tabBarButtonClicked(sender:)), for: .touchUpInside)
             
             self.addSubview(button)
             
             self.tabBarButtons.append(button)
         }
         
         _ = self.addLine(position: .top, color: UIColor.hexString("#E6E9ED"), ply: 0.5, leftPadding: 0, rightPadding: 0)
     }
     
     @objc private func tabBarButtonClicked(sender: XHTeamCustomTabBarButton) {
         if let handler = self.onSelect {
             handler(sender.tag)
         }
     }
     
 }

 // MARK: - 自定义TabBarButton
 class XHTeamCustomTabBarButton: UIButton {
     
     var titleRect: CGRect?
     var imageRect: CGRect?
     
     override var isSelected: Bool {
         didSet {
             if isSelected {
                 self.titleFont = UIFont.Semibold(11.0)
             } else {
                 self.titleFont = UIFont.regular(11.0)
             }
         }
     }
     
     override init(frame: CGRect) {
         super.init(frame:frame)
         buildUI()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     private func buildUI() {
         imageRect = CGRect(x: (self.viewFrameWidth - 26.0)/2.0, y: 5.0, width: 26.0, height: 26.0)
         titleRect = CGRect(x: 0, y: self.viewFrameHeight - 3 - 11, width: self.viewFrameWidth, height: 11.0)
         
         self.backgroundColor = UIColor.clear
         self.titleLabel?.textAlignment = .center
         self.titleLabel?.numberOfLines = 0
     }
     
     //指定按钮图像边界
     override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
         return self.imageRect ?? CGRect.zero
     }
     
     // 指定文字标题边界
     override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
         return self.titleRect ?? CGRect.zero
     }
     
 }


 /*
  * 难点一：如何隐藏tabBar顶部的细线
  // 去掉系统tabBar的顶部细线(没起作用)
  let image = UIImage.imageWithColor(color: UIColor.clear, size: CGSize(width: self.tabBar.width, height: self.tabBar.height))
  self.tabBar.backgroundImage = image
  self.tabBar.shadowImage = image
  
  // 去掉系统tabBar的顶部细线
  self.tabBar.clipsToBounds = true
  
  
  * 难点二：如何隐藏系统TabBar的标题：
  在XHBaseViewController中重写title的set和get方法：
  
  // 防止tabBar出现标题的方法
  override var title: String? {
  set {
  self.navigationItem.title = newValue
  self.tabBarItem.title = ""
  self.fakeNavBar?.titleLabel?.text = newValue
  }
  
  get {
  return super.title
  }
  }
  
  */

 */
