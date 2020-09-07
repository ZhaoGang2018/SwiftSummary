//
//  SpeedQueue.swift
//  LocationUpdates
//
//  Created by Quinn Von on 2020/4/2.
//  Copyright © 2020 Quinn Von. All rights reserved.
//

// MARK:README
/// GCD 中不需要接触到线程，可以通过使用队列来间接处理
/// GCD 中有四种队列，其中三种用户可用，分别是：主队列、全局队列、自定义队列、管理队列（内部队列，不公开，用来扮演管理的角色，GCD定时器就用到了管理队列 https://www.neroxie.com/2019/01/22/%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3GCD%E4%B9%8Bdispatch-queue/）
/// 耗时操作放在子线程，但不要开辟太多子线程，否则会增加CPU的调度时间
/// 一般情况下，线程会在线程池中，系统为双核CPU，9.3.1 系统 创建 64条线程，测试如下：
        /*
        ip5（双核）,9.3.1的系统：会创建64个线程
        ip6（双核 ），8.1.1的系统：会创建三百多个线程
        模拟器上，都是9以上的系统：会创建64个线程
        */
/// 线程在使用完毕之后，并不会被销毁，而是出于一种等待状态
/// 每当有队列携带任务过来时，线程就会被重新启用
/// 线程是最小的处理单元，即：包括完整的逻辑，计算，存储，控制
/// 当CPU轮询时，如果卡住，分配的时间片用尽，那么就要等待下一次轮询

// MARK: SpeedQueue 用于开发时的队列异步处理 提供四种，主队列、全局队列、自定义并发队列、自定义串行队列
import Foundation

class SpeedyQueue{
    
    /// 并发
    private static let concurrent = DispatchQueue(label: "top.xhey.www.concurrent",attributes: .concurrent)
    /// 串行
    private static let serial = DispatchQueue(label: "top.xhey.www.serial")

    // MARK: 主队列异步
    /// - Parameters:
    ///   - group: 提交到队列进行异步调用的一个组块
    ///   - qos: 优先级
    ///   - flags: 执行描述，决定如何执行: （如：barrier，可以实现分割
    ///   - work: 代码块
    
//     SpeedQueue.mainAsync(flags: .barrier) {
//         Thread.sleep(forTimeInterval: 0.25)
//         print("a")
//     }
//     SpeedQueue.mainAsync(flags: .barrier) {
//         Thread.sleep(forTimeInterval: 0.25)
//         print("barrier")
//     }
//     SpeedQueue.mainAsync(flags: .barrier) {
//         Thread.sleep(forTimeInterval: 0.25)
//         print("c")
//     }
//     print:
//                 a
//                 barrier
//                 b
     
    static func mainAsync(group: DispatchGroup? = nil, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void){
        DispatchQueue.main.async(group: group, qos: qos, flags: flags, execute: work)
    }
    
    
    // MARK: 主队列延时异步
    /// - Parameters:
    ///   - wallDeadline: 延时时长
    ///   - qos: 优先级
    ///   - flags: 执行描述，决定如何执行: （如：barrier，可以实现分割）
    ///   - work: 代码块

    static func mainAsyncAfter(wallDeadline: DispatchWallTime, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void){
        /// deadline 系统会使用默认时钟来进行计时, 然而当系统休眠的时候, 默认时钟是不走的
        /// wallDeadline 可以让计时器按照真实时间间隔进行计时;
        DispatchQueue.main.asyncAfter(wallDeadline: wallDeadline, qos: qos, flags: flags, execute: work)
    }
    
    // MARK: ======

    // MARK: 全局并发队列异步
    static func globalAsync(group: DispatchGroup? = nil, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void){
        DispatchQueue.global().async(group: group, qos: qos, flags: flags, execute: work)
    }

    // MARK: 全局并发队列延时异步
    static func globalAsyncAfter(wallDeadline: DispatchWallTime, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void){
        /// deadline 系统会使用默认时钟来进行计时, 然而当系统休眠的时候, 默认时钟是不走的
        /// wallDeadline 可以让计时器按照真实时间间隔进行计时;
        DispatchQueue.global().asyncAfter(wallDeadline: wallDeadline, qos: qos, flags: flags, execute: work)
    }

    // MARK: ======

    // MARK: 自定义并发队列异步
    static func concurrentAsync(group: DispatchGroup? = nil, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void){
        SpeedyQueue.concurrent.async(group: group, qos: qos, flags: flags, execute: work)
    }
    // MARK: 自定义并发队列延时异步
    static func concurrentAsyncAfter(wallDeadline: DispatchWallTime, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void){
        /// deadline 系统会使用默认时钟来进行计时, 然而当系统休眠的时候, 默认时钟是不走的
        /// wallDeadline 可以让计时器按照真实时间间隔进行计时;
        SpeedyQueue.concurrent.asyncAfter(wallDeadline: wallDeadline, qos: qos, flags: flags, execute: work)
    }
    // MARK: ======

    
    // MARK: 自定义串行队列异步
    static func serialAsync(group: DispatchGroup? = nil, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void){
        SpeedyQueue.concurrent.async(group: group, qos: qos, flags: flags, execute: work)
    }
    // MARK: 自定义串行队列延时异步
    static func serialAsyncAfter(wallDeadline: DispatchWallTime, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void){
        /// deadline 系统会使用默认时钟来进行计时, 然而当系统休眠的时候, 默认时钟是不走的
        /// wallDeadline 可以让计时器按照真实时间间隔进行计时;
        SpeedyQueue.serial.asyncAfter(wallDeadline: wallDeadline, qos: qos, flags: flags, execute: work)
    }
    
}


