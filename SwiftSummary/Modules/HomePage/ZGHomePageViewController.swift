//
//  ZGHomePageViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/1/9.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

enum ZGFeatureItemType: String {
    case chart = "绘制图表"
    case xibTest = "可视化编程"
    case toast = "Toast提示"
    case GCD = "GCD"
    case dataStructure = "数据结构"
    case KVO = "KVO的实现原理"
    case timer = "定时器"
    case Breakpoint = "断点续传"
    case BrowseImage = " 浏览图片"
}


class ZGHomePageViewController: XHBaseViewController {
    
    var listView: ZGHomePageView?
    var items: [ZGFeatureItemType] = [.chart, .xibTest, .toast, .GCD, .dataStructure, .KVO, .timer, .Breakpoint, .BrowseImage]
    
    var reachability: Reachability?
    let hostNames = [nil, "google.com", "invalidhost"]
    var hostIndex = 0
    
    deinit {
//        stopNotifier()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我"
        self.leftButtonStyle = .hide
        
        listView = ZGHomePageView()
        view.addSubview(listView!)
        listView?.snp.makeConstraints { (make) in
            make.top.equalTo(SpeedyApp.statusBarAndNavigationBarHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-SpeedyApp.tabBarBottomHeight)
        }
        self.listView?.configData(list: items)
        self.listView?.listTableView?.reloadData()
    }
    
    private func cellOnSelect(type: ZGFeatureItemType) {
        
        var vc: UIViewController?
        
        switch type {
        case .chart:
            vc = ZGChartViewController()
        case .xibTest:
            //            vc = ZGXibTestViewController()
            vc = UIStoryboard(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "ZGStoryboardFirstViewController") as! ZGStoryboardFirstViewController
            
        case .toast:
            vc = ZGToastViewController.init(style: .grouped)
        case .GCD:
            vc = UIStoryboard(name: "HomePage", bundle: Bundle.main).instantiateViewController(withIdentifier: "GCDViewController")
        case .dataStructure:
            vc = UIStoryboard(name: "HomePage", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZGDataStructureViewController")
        case .KVO:
            vc = UIStoryboard(name: "HomePage", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZGKVOTestViewController")
        case .timer:
            vc = UIStoryboard(name: "HomePage", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZGTimerViewController")
        case .Breakpoint:
            vc = UIStoryboard.buildViewController(storyboardName: "HomePage", classType: ZGBreakpointViewController.self)
            
        case .BrowseImage:
            vc = ZGBrowseImageViewController()
        }
        
        if let vc = vc {
            vc.title = type.rawValue
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ZGHomePageViewController: SpeedySignalProtocol {
    
    func handleUISignal(_ signal:SpeedySignal) {
        if signal.name == ZGHomePageView.cellSelectSignal {
            if let model = signal.parameter as? ZGFeatureItemType {
                cellOnSelect(type: model)
            }
        }
    }
}


// MARK: - 网络监控
extension ZGHomePageViewController {
    
    func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: true)
        startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startHost(at: (index + 1) % 3)
        }
    }
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = try? Reachability(hostname: hostName)
            XHLogDebug(hostName)
        } else {
            reachability = try? Reachability()
            XHLogDebug("No host name")
        }
        self.reachability = reachability
        //            XHLogDebug("--- set up with host name: \(hostNameLabel.text!)")
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                self.updateLabelColourWhenReachable(reachability)
            }
            reachability?.whenUnreachable = { reachability in
                self.updateLabelColourWhenNotReachable(reachability)
            }
        } else {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reachabilityChanged(_:)),
                name: .reachabilityChanged,
                object: reachability
            )
        }
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            XHLogDebug("Unable to start\nnotifier")
            return
        }
    }
    
    func stopNotifier() {
        XHLogDebug("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    func updateLabelColourWhenReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.connection)")
        if reachability.connection == .wifi {
            
        } else {
            
        }
        
        XHLogDebug("\(reachability.connection)")
    }
    
    func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
        
        XHLogDebug("\(reachability.description) - \(reachability.connection)")
        XHLogDebug("\(reachability.connection)")
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .unavailable {
            updateLabelColourWhenReachable(reachability)
        } else {
            updateLabelColourWhenNotReachable(reachability)
        }
    }
}


