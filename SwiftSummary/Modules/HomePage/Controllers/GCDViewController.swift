//
//  GCDViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/6/20.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

class GCDViewController: XHBaseViewController {

    
    @IBOutlet weak var button: UIButton!
    
    var timer = DispatchSource.makeTimerSource()
    var count = Date().timeIntervalSince1970
    var isSuspend = true
    
    deinit {
        if self.isSuspend {
            self.timer.resume()
        }
        self.timer.cancel()
        XHLogDebug("deinit - GCDViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         //串行队列
         let serial = DispatchQueue(label: "serial",attributes: .init(rawValue:0))
         //并发队列
         let concurrent = DispatchQueue(label: "serial",attributes: .concurrent)
         //主队列
         let mainQueue = DispatchQueue.main
         //全局队列
         let global = DispatchQueue.global()
         */
        
        
        _ = view.addTapGestureRecognizer(target: self, action: #selector(tapAction))
        
         timerTest()
    }
    
    @objc private func tapAction() {
//        syncConcurrent()
//        asyncConcurrent()
//        syncSerial()
//        asyncSerial()
//        asyncMain()
        
//        lockTest()
    }
    
    private func timerTest() {
        
        // repeating代表间隔1秒
        timer.schedule(deadline: .now(), repeating: 1)
        
        timer.setEventHandler { [weak self] in
            if let weakSelf = self {
                if weakSelf.count<0{
                    weakSelf.timer.cancel()
                }else {
                    DispatchQueue.main.async {
                        weakSelf.button.setTitle(weakSelf.returnTimeTofammater(times: weakSelf.count), for: .normal)
                        weakSelf.count -= 1
                    }
                }
            }
        }
    }
    
    // 开始点击倒计时
    @IBAction func starAction(_ sender: UIButton) {
        
        if sender.isSelected == true {
            timer.suspend()
            sender.setTitle("暂停", for: .normal)
            isSuspend = true
        }else{
            timer.resume()
            isSuspend = false
        }
        sender.isSelected = !sender.isSelected
    }
    
    //将多少秒传进去得到00:00:00这种格式
    func returnTimeTofammater(times:TimeInterval) -> String {
        if times==0{
            return "00:00:00"
        }
        var Min = Int(times / 60)
        let second = Int(times.truncatingRemainder(dividingBy: 60));
        var Hour = 0
        if Min>=60 {
            Hour = Int(Min / 60)
            Min = Min - Hour*60
            return String(format: "%02d : %02d : %02d", Hour, Min, second)
        }
        return String(format: "00 : %02d : %02d", Min, second)
    }
    
    //根据显示的字符串00:00:00转化成秒数
    func getSecondsFromTimeStr(timeStr:String) -> Int {
        if timeStr.isEmpty {
            return 0
        }
        let timeArry = timeStr.replacingOccurrences(of: "：", with: ":").components(separatedBy: ":")
        var seconds:Int = 0
        if timeArry.count > 0 && isPurnInt(string: timeArry[0]){
            let hh = Int(timeArry[0])
            if hh! > 0 {
                seconds += hh!*60*60
            }
        }
        if timeArry.count > 1 && isPurnInt(string: timeArry[1]){
            let mm = Int(timeArry[1])
            if mm! > 0 {
                seconds += mm!*60
            }
        }
        if timeArry.count > 2 && isPurnInt(string: timeArry[2]){
            let ss = Int(timeArry[2])
            if ss! > 0 {
                seconds += ss!
            }
        }
        return seconds
    }
    
    //扫描字符串的值
    func isPurnInt(string: String) -> Bool {
        let scan:Scanner = Scanner.init(string: string)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    
    // MARK: - 锁
    private func lockTest() {
        
        let lock = NSLock()
        
        func test(value: Int) {
            lock.lock()
            if value > 0 {
                print("value = \(value)")
                sleep(1)
                test(value: value - 1)
            }
            lock.unlock()
        }
        
        DispatchQueue.global().async {
            test(value: 5)
        }
        
        /*
        // 这段代码是一个典型的死锁情况
           NSLock *lock = [[NSLock alloc] init];
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               
               static void (^RecursiveMethod)(int);
               
               RecursiveMethod = ^(int value) {
                   [lock lock];
                   if (value > 0) {
                       NSLog(@"value = %d", value);
                       sleep(1);
                       RecursiveMethod(value - 1);
                   }
                   [lock unlock];
               };
               
               RecursiveMethod(5);
           });
        */
    }
    
    /**
    * 异步执行 + 主队列
    * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
    */
    private func asyncMain() {
        
        XHLogDebug("asyncMain---begin")
        
        let queue = DispatchQueue.main
        queue.async {
            sleep(2) // 模拟耗时操作
            XHLogDebug("1---\(Thread.current)")
        }
        
        queue.async {
            sleep(2) // 模拟耗时操作
            XHLogDebug("2---\(Thread.current)")
        }
        
        queue.async {
            sleep(2) // 模拟耗时操作
            XHLogDebug("3---\(Thread.current)")
        }
        
        XHLogDebug("asyncMain---end")
        
        /*
         [06-20 19:14:09]-[DEBUG]-->asyncMain---begin
         [06-20 19:14:09]-[DEBUG]-->asyncMain---end
         [06-20 19:14:11]-[DEBUG]-->1---<NSThread: 0x28305ce00>{number = 1, name = main}
         [06-20 19:14:13]-[DEBUG]-->2---<NSThread: 0x28305ce00>{number = 1, name = main}
         [06-20 19:14:15]-[DEBUG]-->3---<NSThread: 0x28305ce00>{number = 1, name = main}
         */
        
        /*
         在 异步执行 + 主队列 可以看到：

         所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（虽然 异步执行 具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中）。
         所有任务是在打印的 syncConcurrent---begin 和 syncConcurrent---end 之后才开始执行的（异步执行不会做任何等待，可以继续执行任务）。
         任务是按顺序执行的（因为主队列是 串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行）。

         */
    }
    
    /**
     * 同步执行 + 主队列
     * 特点(主线程调用)：互等卡主不执行或直接崩溃
     * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
     */
    private func syncMain() {
        XHLogDebug("asyncSerial---begin")
        
        let queue = DispatchQueue.main
        queue.sync {
            sleep(2) // 模拟耗时操作
            XHLogDebug("1---\(Thread.current)")
        }
        
        queue.sync {
            sleep(2) // 模拟耗时操作
            XHLogDebug("2---\(Thread.current)")
        }
        
        queue.sync {
            sleep(2) // 模拟耗时操作
            XHLogDebug("3---\(Thread.current)")
        }
        
        XHLogDebug("asyncSerial---end")
        
        /*
         在主线程中使用 同步执行 + 主队列 可以惊奇的发现：

         追加到主线程的任务 1、任务 2、任务 3 都不再执行了，而且 syncMain---end 也没有打印，在 XCode 9 及以上版本上还会直接报崩溃。这是为什么呢？
         这是因为我们在主线程中执行 syncMain 方法，相当于把 syncMain 任务放到了主线程的队列中。而 同步执行 会等待当前队列中的任务执行完毕，才会接着执行。那么当我们把 任务 1 追加到主队列中，任务 1 就在等待主线程处理完 syncMain 任务。而syncMain 任务需要等待 任务 1 执行完毕，才能接着执行。

         那么，现在的情况就是 syncMain 任务和 任务 1 都在等对方执行完毕。这样大家互相等待，所以就卡住了，所以我们的任务执行不了，而且 syncMain---end 也没有打印。
         */
        
        /*
         在其他线程中使用 同步执行 + 主队列 可看到：

         所有任务都是在主线程（非当前线程）中执行的，没有开启新的线程（所有放在主队列中的任务，都会放到主线程中执行）。
         所有任务都在打印的 syncConcurrent---begin 和 syncConcurrent---end 之间执行（同步任务 需要等待队列的任务执行结束）。
         任务是按顺序执行的（主队列是 串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行）。
         为什么现在就不会卡住了呢？

         因为syncMain 任务 放到了其他线程里，而 任务 1、任务 2、任务3 都在追加到主队列中，这三个任务都会在主线程中执行。syncMain 任务 在其他线程中执行到追加 任务 1 到主队列中，因为主队列现在没有正在执行的任务，所以，会直接执行主队列的 任务1，等 任务1 执行完毕，再接着执行 任务 2、任务 3。所以这里不会卡住线程，也就不会造成死锁问题。
         
         [06-20 19:10:34]-[DEBUG]-->asyncSerial---begin
         [06-20 19:10:36]-[DEBUG]-->1---<NSThread: 0x280478e00>{number = 1, name = main}
         [06-20 19:10:38]-[DEBUG]-->2---<NSThread: 0x280478e00>{number = 1, name = main}
         [06-20 19:10:40]-[DEBUG]-->3---<NSThread: 0x280478e00>{number = 1, name = main}
         [06-20 19:10:40]-[DEBUG]-->asyncSerial---end
         */
    }
    
    
    /**
     * 异步执行 + 串行队列
     * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
     */
    private func asyncSerial() {
        
        XHLogDebug("asyncSerial---begin")
        
        let concurrent = DispatchQueue(label: "test.queue",attributes: .init(rawValue:0))
        concurrent.async {
            sleep(2) // 模拟耗时操作
            XHLogDebug("1---\(Thread.current)")
        }
        
        concurrent.async {
            sleep(2) // 模拟耗时操作
            XHLogDebug("2---\(Thread.current)")
        }
        
        concurrent.async {
            sleep(2) // 模拟耗时操作
            XHLogDebug("3---\(Thread.current)")
        }
        
        XHLogDebug("asyncSerial---end")
        
        /*
         [06-20 19:04:48]-[DEBUG]-->asyncSerial---begin
         [06-20 19:04:48]-[DEBUG]-->asyncSerial---end
         [06-20 19:04:50]-[DEBUG]-->1---<NSThread: 0x283bb6200>{number = 5, name = (null)}
         [06-20 19:04:52]-[DEBUG]-->2---<NSThread: 0x283bb6200>{number = 5, name = (null)}
         [06-20 19:04:54]-[DEBUG]-->3---<NSThread: 0x283bb6200>{number = 5, name = (null)}

         */
        
        /*
         在 异步执行 + 串行队列 可以看到：

         开启了一条新线程（异步执行 具备开启新线程的能力，串行队列 只开启一个线程）。
         所有任务是在打印的 syncConcurrent---begin 和 syncConcurrent---end 之后才开始执行的（异步执行 不会做任何等待，可以继续执行任务）。
         任务是按顺序执行的（串行队列 每次只有一个任务被执行，任务一个接一个按顺序执行）。
         */
    }
    
    /**
    * 同步执行 + 串行队列
    * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
    */
    private func syncSerial() {
        
        XHLogDebug("syncSerial---begin")
        
        let concurrent = DispatchQueue(label: "test.queue",attributes: .init(rawValue:0))
        concurrent.sync {
            sleep(2) // 模拟耗时操作
            XHLogDebug("1---\(Thread.current)")
        }
        
        concurrent.sync {
            sleep(2) // 模拟耗时操作
            XHLogDebug("2---\(Thread.current)")
        }
        
        concurrent.sync {
            sleep(2) // 模拟耗时操作
            XHLogDebug("3---\(Thread.current)")
        }
        
        XHLogDebug("syncSerial---end")
        
        /*
         [06-20 19:00:05]-[DEBUG]-->syncSerial---begin
         [06-20 19:00:07]-[DEBUG]-->1---<NSThread: 0x283b68e00>{number = 1, name = main}
         [06-20 19:00:09]-[DEBUG]-->2---<NSThread: 0x283b68e00>{number = 1, name = main}
         [06-20 19:00:11]-[DEBUG]-->3---<NSThread: 0x283b68e00>{number = 1, name = main}
         [06-20 19:00:11]-[DEBUG]-->syncSerial---end
         */
        
        /*
         在 同步执行 + 串行队列 可以看到：

         所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（同步执行 不具备开启新线程的能力）。
         所有任务都在打印的 syncConcurrent---begin 和 syncConcurrent---end 之间执行（同步任务 需要等待队列的任务执行结束）。
         任务是按顺序执行的（串行队列 每次只有一个任务被执行，任务一个接一个按顺序执行）。
         */
        
    }
    
    /**
     * 异步执行 + 并发队列
     * 特点：可以开启多个线程，任务交替（同时）执行。
     */
    private func asyncConcurrent() {
        XHLogDebug("syncConcurrent---begin")
        
        let concurrent = DispatchQueue(label: "test.queue",attributes: .concurrent)
        concurrent.async {
            sleep(2) // 模拟耗时操作
            XHLogDebug("1---\(Thread.current)")
        }
        
        concurrent.async {
            sleep(2) // 模拟耗时操作
            XHLogDebug("2---\(Thread.current)")
        }
        
        concurrent.async {
            sleep(2) // 模拟耗时操作
            XHLogDebug("3---\(Thread.current)")
        }
        
        XHLogDebug("syncConcurrent---end")
        
        /*
         [06-20 18:53:13]-[DEBUG]-->syncConcurrent---begin
         [06-20 18:53:13]-[DEBUG]-->syncConcurrent---end
         [06-20 18:53:15]-[DEBUG]-->3---<NSThread: 0x281dd9280>{number = 8, name = (null)}
         [06-20 18:53:15]-[DEBUG]-->1---<NSThread: 0x281d12640>{number = 5, name = (null)}
         [06-20 18:53:15]-[DEBUG]-->2---<NSThread: 0x281d3fb40>{number = 7, name = (null)}

         */
        
        /*
         在 异步执行 + 并发队列 中可以看出：

         除了当前线程（主线程），系统又开启了 3 个线程，并且任务是交替/同时执行的。（异步执行 具备开启新线程的能力。且 并发队列 可开启多个线程，同时执行多个任务）。
         所有任务是在打印的 syncConcurrent---begin 和 syncConcurrent---end 之后才执行的。说明当前线程没有等待，而是直接开启了新线程，在新线程中执行任务（异步执行 不做等待，可以继续执行任务）。
         */
    }
    
    /**
     * 同步执行 + 并发队列
     * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
     */
    private func syncConcurrent() {
        XHLogDebug("syncConcurrent---begin")
        
        let concurrent = DispatchQueue(label: "test.queue",attributes: .concurrent)
        concurrent.sync {
            sleep(2) // 模拟耗时操作
            XHLogDebug("1---\(Thread.current)")
        }
        
        concurrent.sync {
            sleep(2) // 模拟耗时操作
            XHLogDebug("2---\(Thread.current)")
        }
        
        concurrent.sync {
            sleep(2) // 模拟耗时操作
            XHLogDebug("3---\(Thread.current)")
        }
        
        XHLogDebug("syncConcurrent---end")
        
        /*
         [06-20 18:48:07]-[DEBUG]-->syncConcurrent---begin
         [06-20 18:48:09]-[DEBUG]-->1---<NSThread: 0x281a50e00>{number = 1, name = main}
         [06-20 18:48:11]-[DEBUG]-->2---<NSThread: 0x281a50e00>{number = 1, name = main}
         [06-20 18:48:13]-[DEBUG]-->3---<NSThread: 0x281a50e00>{number = 1, name = main}
         [06-20 18:48:13]-[DEBUG]-->syncConcurrent---end
         */
        
        /*
         从 同步执行 + 并发队列 中可看到：

         所有任务都是在当前线程（主线程）中执行的，没有开启新的线程（同步执行不具备开启新线程的能力）。
         所有任务都在打印的 syncConcurrent---begin 和 syncConcurrent---end 之间执行的（同步任务 需要等待队列的任务执行结束）。
         任务按顺序执行的。按顺序执行的原因：虽然 并发队列 可以开启多个线程，并且同时执行多个任务。但是因为本身不能创建新线程，只有当前线程这一个线程（同步任务 不具备开启新线程的能力），所以也就不存在并发。而且当前线程只有等待当前队列中正在执行的任务执行完毕之后，才能继续接着执行下面的操作（同步任务 需要等待队列的任务执行结束）。所以任务只能一个接一个按顺序执行，不能同时被执行。
         */
    }
    
    
    
}

/*
 //串行队列
 let serial = DispatchQueue(label: "serial",attributes: .init(rawValue:0))
 //并发队列
 let concurrent = DispatchQueue(label: "serial",attributes: .concurrent)
 //主队列
 let mainQueue = DispatchQueue.main
 //全局队列
 let global = DispatchQueue.global()
 
 
 //串行队列
 let serial = DispatchQueue(label: "serial",attributes: .init(rawValue:0))
 for i in 0...10 {
     serial.sync {
         sleep(arc4random()%3)//休眠时间随机
         print(i)
     }
 }
 
 //串行队列
 let serial = DispatchQueue(label: "serial",attributes: .init(rawValue:0))
 print(Thread.current)//主线程
 for i in 0...10 {
     serial.async {
         sleep(arc4random()%3)//休眠时间随机
         print(i,Thread.current)//子线程
     }
 }
 */

