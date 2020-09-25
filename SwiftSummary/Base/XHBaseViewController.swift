//
//  XHBaseViewController.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/5.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit
import SnapKit
import Hero

public typealias XHNomalOption = () -> ()

class XHBaseFullScreenViewController:XHBaseViewController{
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .fullScreen
    }
}
class XHBaseViewController: UIViewController{
    
    var fakeNavBar: XHFakeNavigationBar?
    var bgImageView: UIImageView?
    
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
    ///添加仿照系统的titleView
    private weak var _titleView:UIView?
    var titleView:UIView?{
        get{
            return _titleView
        }
        set{
            
            _titleView?.removeFromSuperview()
            if let titleLabel = fakeNavBar?.titleLabel{
                titleLabel.removeFromSuperview()
            }
            
            _titleView = newValue
            
            if _titleView != nil{
                fakeNavBar?.addSubview(_titleView!)
            }
        }
    }
    
    var isShowLeftButton: Bool = true {
        didSet {
            self.fakeNavBar?.leftButton?.isHidden = !isShowLeftButton
        }
    }
    
    var leftButtonStyle: XHFakeNavigationLeftButtonStyle = .back {
        didSet {
            self.fakeNavBar?.leftButtonStyle = leftButtonStyle
        }
    }
    
    var rightButtonStyle: XHFakeNavigationRightButtonStyle = .hide {
        didSet {
            self.fakeNavBar?.rightButtonStyle = rightButtonStyle
        }
    }
    
    deinit {
        XHLogDebug("deinit - XHBaseViewController")
//        self.cancelNetworkTask()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImageView = UIImageView(imageName: "04.JPG")
        bgImageView?.contentMode = .scaleAspectFill
        bgImageView?.clipsToBounds = true
        view.addSubview(bgImageView!)
        bgImageView?.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
//        self.requestCallKey = NSUUID().uuidString
        view.backgroundColor = UIColor.fromHex("#EFEFF4")
        buildFakeNavBar()
        
        self.setNavigationBarButton(buttonType: .left, normalImage: UIImage.init(named: "btn_back_on_black")!, selectImage: UIImage.init(named: "btn_back_on_black"), size: CGSize.init(width: 40, height: 40))
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        /*
         self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.white, size: CGSize(width: SCREEN_WIDTH, height: statusBarAndNavigationBarHeight)), for: .default)
         
         self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: UIColor.white, size: CGSize(width: SCREEN_WIDTH, height: statusBarAndNavigationBarHeight))
         */
        
        self.fakeNavBar?.titleLabel?.text = self.navigationItem.title
        self.view.sendSubviewToBack(self.bgImageView!)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK: - 导航条上左右按钮的点击时间
    func handleNavigationBarButton(buttonType : UINavigationBarButtonType) {
        if buttonType == .left {
            self.popOrDismissViewController()
        }
    }
    
    // MARK: - 创建假的导航条
    func buildFakeNavBar() {
        self.fakeNavBar = XHFakeNavigationBar.init()
        self.fakeNavBar?.backgroundColor = UIColor.white
        self.view.addSubview(self.fakeNavBar!)
        self.fakeNavBar?.snp.makeConstraints({ (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(SpeedyApp.statusBarAndNavigationBarHeight)
        })
        
        self.fakeNavBar?.leftButtonHandler = { [weak self] in
            self?.handleNavigationBarButton(buttonType: .left)
        }
        
        self.fakeNavBar?.rightButtonHandler = { [weak self] in
            self?.handleNavigationBarButton(buttonType: .right)
        }
    }
}

// MARK: - 从XHPresentBaseViewController类里移过来的 UIViewControllerTransitioningDelegate
extension XHBaseViewController : UIViewControllerTransitioningDelegate {
    
    
//    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
//
//        let transtionPresent = XHPresentBaseTranstion.init(.present)
//        return transtionPresent
//    }
//
//    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
//
//        let transtionDismiss = XHPresentBaseTranstion.init(.dismiss)
//        return transtionDismiss
//    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
        
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
        return nil
    }
}

// MARK: - 设置真导航条左右按钮的方法
extension XHBaseViewController {
    func setNavigationBarButton(buttonType: UINavigationBarButtonType, normalImage: UIImage?, selectImage: UIImage?, size: CGSize) -> () {
        
        // 设置导航栏按钮
        let button = UIButton.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: size))
        button.contentMode = .scaleAspectFit
        button.setImage(normalImage, for: .normal)
        button.setImage(selectImage, for: .selected)
        
        if buttonType == .left {
            // 这行代码是解决按钮靠左距离太大
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
            button.addTarget(self, action: #selector(didLeftBarButtonTouched), for: .touchUpInside)
            //            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
            
            // 这几行代码是为了解决手势滑动的时候，按钮上的图片被遮挡
            let leftBtn = UIBarButtonItem.init(customView: button)
            let leftSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: self, action: nil)
            leftBtn.width = -20;
            self.navigationItem.leftBarButtonItems = [leftSpace, leftBtn];
            
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
            button.addTarget(self, action: #selector(didRightBarButtonTouched), for: .touchUpInside)
            //            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
            
            // 这几行代码是为了解决手势滑动的时候，按钮上的图片被遮挡
            let rightBtn = UIBarButtonItem.init(customView: button)
            let rightSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: self, action: nil)
            rightSpace.width = -20;
            self.navigationItem.rightBarButtonItems = [rightBtn, rightSpace];
        }
    }
    
    func setNavigationBarButton(buttonType: UINavigationBarButtonType, title: String, titleColor: UIColor, titleFont: UIFont, size: CGSize, edgeInsets: UIEdgeInsets){
        
        // 设置导航栏按钮
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        button.btnTitle = title
        button.titleFont = titleFont
        button.titleColor = titleColor
        button.contentEdgeInsets = edgeInsets
        button.contentMode = .scaleAspectFit
        
        if buttonType == .left {
            button.addTarget(self, action: #selector(didLeftBarButtonTouched), for: .touchUpInside)
            //            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
            
            // 这几行代码是为了解决手势滑动的时候，按钮上的图片被遮挡
            let leftBtn = UIBarButtonItem.init(customView: button)
            let leftSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: self, action: nil)
            leftBtn.width = -20;
            self.navigationItem.leftBarButtonItems = [leftSpace, leftBtn];
            
        } else {
            button.addTarget(self, action: #selector(didRightBarButtonTouched), for: .touchUpInside)
            //            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
            
            // 这几行代码是为了解决手势滑动的时候，按钮上的图片被遮挡
            let rightBtn = UIBarButtonItem.init(customView: button)
            let rightSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: self, action: nil)
            rightSpace.width = -20;
            self.navigationItem.rightBarButtonItems = [rightBtn, rightSpace];
        }
    }
    
    func setNavigationBarButton(buttonType: UINavigationBarButtonType, customView: UIView) {
        
        if buttonType == .left {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: customView)
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: customView)
        }
    }
    
    
    @objc func didLeftBarButtonTouched(sender : UIButton) {
        
        self.handleNavigationBarButton(buttonType: .left)
    }
    
    
    @objc func didRightBarButtonTouched(sender : UIButton) {
        self.handleNavigationBarButton(buttonType: .right)
    }
}


extension XHFakeNavigationBar{
    
    @discardableResult func fastGenerateRightItem(title:String?=nil,size:CGSize?=nil,target:Any,action: Selector)->UIButton{
        
        let btn = UIButton(title: title ?? "完成", titleColor: UIColor.white, titleFont: UIFont.Semibold(16),cornerRadius: 4)
        
        btn.setBackgroundImage(UIImage.init(color: UIColor.blueColor_xh()), for: .normal)
        
        setRightCustomView(view: btn)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(-11)
            make.size.equalTo(size ?? CGSize.init(width: 54, height: 28))
            make.centerY.equalToSuperview().offset(SpeedyApp.statusBarHeight*0.5)
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        return btn
    }
}
