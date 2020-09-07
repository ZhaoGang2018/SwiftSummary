//
//  ZGKVOTestViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/6/23.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

class Person: NSObject {
    // 必须使用“@objc dynamic”修饰
    @objc dynamic var name : String  = " "
    @objc dynamic var age : Int = 18
    
    init(name : String) {
        self.name = name
        super.init()
    }
}

class ZGKVOTestViewController: XHBaseViewController {
    
    var person = Person(name: "v587")
    
    //添加监听后,使用完必须移除监听(一个add 对应一个 remove)
    deinit {
        person.removeObserver(self, forKeyPath: "name", context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加观察者
        /*
         为对象p添加一个观察者（监听器）
         Observer：观察者（监听器）
         KeyPath：属性名（需要监听哪个属性）
         options: [.New, .Old] 同时监听新值和旧值的改变
         */
        person.addObserver(self, forKeyPath: "name", options: [.new, .old], context: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        person.name = "sunke"
    }
    
    /**
     当利用KVO监听到某个对象的属性值发生了改变，就会自动调用这个
     
     - parameter keyPath: 哪个属性被改了
     - parameter object:  哪个对象的属性被改了
     - parameter change:  改成咋样
     - parameter context: 当初addObserver时的context参数值
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "name" {
            let oldValue = change![NSKeyValueChangeKey.oldKey] as? String
            let newValue = change![NSKeyValueChangeKey.newKey] as? String
            
            print("oldValue = \(String(describing: oldValue)), newValue = \(String(describing: newValue))")
            print("--------------")
            
            print("keyPath = \(String(describing: keyPath))")
            print("object = \(String(describing: object))")
            print("change = \(String(describing: change))")
            print("context = \(String(describing: context))")
        }
    }
}

/*
 KVO基本原理：
 1.KVO是基于runtime机制实现的
 2.当某个类的属性对象第一次被观察时，系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的setter 方法。派生类在被重写的setter方法内实现真正的通知机制
 3.如果原类为Person，那么生成的派生类名为NSKVONotifying_Person
 4. 每个类对象中都有一个isa指针指向当前类，当一个类对象的第一次被观察，那么系统会偷偷将isa指针指向动态生成的派生类，从而在给被监控属性赋值时执行的是派生类的setter方法
 5.键值观察通知依赖于NSObject 的两个方法: willChangeValueForKey: 和 didChangevlueForKey:；在一个被观察属性发生改变之前， willChangeValueForKey:一定会被调用，这就 会记录旧的值。而当改变发生后，didChangeValueForKey:会被调用，继而 observeValueForKey:ofObject:change:context: 也会被调用。
 
 
 KVO深入原理：
 
 1.Apple 使用了 isa 混写（isa-swizzling）来实现 KVO 。当观察对象A时，KVO机制动态创建一个新的名为：?NSKVONotifying_A的新类，该类继承自对象A的本类，且KVO为NSKVONotifying_A重写观察属性的setter?方法，setter?方法会负责在调用原?setter?方法之前和之后，通知所有观察对象属性值的更改情况。
 2.NSKVONotifying_A类剖析：在这个过程，被观察对象的 isa 指针从指向原来的A类，被KVO机制修改为指向系统新创建的子类 NSKVONotifying_A类，来实现当前类属性值改变的监听；
 3.所以当我们从应用层面上看来，完全没有意识到有新的类出现，这是系统“隐瞒”了对KVO的底层实现过程，让我们误以为还是原来的类。但是此时如果我们创建一个新的名为“NSKVONotifying_A”的类()，就会发现系统运行到注册KVO的那段代码时程序就崩溃，因为系统在注册监听的时候动态创建了名为NSKVONotifying_A的中间类，并指向这个中间类了。
 4.（isa 指针的作用：每个对象都有isa 指针，指向该对象的类，它告诉 Runtime 系统这个对象的类是什么。所以对象注册为观察者时，isa指针指向新子类，那么这个被观察的对象就神奇地变成新子类的对象（或实例）了。）?因而在该对象上对 setter 的调用就会调用已重写的 setter，从而激活键值通知机制。
 5.子类setter方法剖析：KVO的键值观察通知依赖于 NSObject 的两个方法:willChangeValueForKey:和 didChangevlueForKey:，在存取数值的前后分别调用2个方法： 被观察属性发生改变之前，willChangeValueForKey:被调用，通知系统该 keyPath?的属性值即将变更；当改变发生后， didChangeValueForKey: 被调用，通知系统该 keyPath?的属性值已经变更；之后，?observeValueForKey:ofObject:change:context: 也会被调用。且重写观察属性的setter?方法这种继承方式的注入是在运行时而不是编译时实现的。
 
 
 */

/*
 无法使用KVO的情况:
 
 1、无法对非NSObject子类进行KVO操作
 
 可以通过Swift本身的属性观察特性，进行对应实现。可以参考三方Observable-Swift ，不推荐直接使用，因为当前只支持到swift3.0
 2、父类属性没有进行动态声明，但是需要进行KVO操作
 
 可以通过继承父类，重写对应属性，并使用“@objc dynamic”修饰
 
 作者：Lucyfa_LLL
 链接：https://www.jianshu.com/p/f64b8c0f2480
 来源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
