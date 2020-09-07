//
//  ZGTimerViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/6/26.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

class ZGTimerViewController: XHBaseViewController {
    
    @IBOutlet weak var showLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var displayLink: CADisplayLink?
    
    deinit {
        XHLogDebug("deinit - ZGTimerViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budlingDisplayLink()
        
//        self.firstTimer()
    }
    
    // MARK: 创建一个CADisplayLink的对象
    func budlingDisplayLink() {
        // 创建对象
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkClick))
        // 设置触发频率
        //设置一秒内有几帧刷新，默认60，即是一秒内有60帧执行刷新调用。
        displayLink?.preferredFramesPerSecond = 1
        // 加入循环
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        
        // 暂停帧的刷新 true:停 ; false:开始
        displayLink?.isPaused = true
        // 停止定时器
        displayLink?.invalidate()
    }
    
    @objc func displayLinkClick() {
        
        self.showLabel.text = Date().toString()
        
        
//        // 当前帧开始刷新的时间
//        print(displayLink.timestamp)
//        // 一帧刷新使用的时间
//        print(displayLink.duration)
//        // 下一帧开始刷新的时间
//        print(displayLink.targetTimestamp)
        // TODO: displayLink.timestamp 与 displayLink.targetTimestamp 相差 displayLink.duration ；即是 ： displayLink.duration  = displayLink.targetTimestamp - displayLink.timestamp 的关系。
        
//        XHLogDebug("开始刷新------")
        
    }
    
}


extension ZGTimerViewController {
    // TODO : 第一种Timer的创建
    func firstTimer() -> Void {
        let timer = Timer(timeInterval: 1, repeats:true) { [weak self] (kTimer) in
            //                print("定时器启动了")
            self?.showLabel.text = Date().toString()
        }
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        // TODO : 启动定时器
        timer.fire()
    }
}
