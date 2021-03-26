//
//  ZGResponderViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2021/1/12.
//  Copyright © 2021 zhaogang. All rights reserved.
//

import UIKit

class ZGResponderChainViewController: XHBaseViewController {
    
    var view1: ZGView1?
    
    deinit {
        XHLogDebug("deinit - ZGResponderChainViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var responder = self.view.next
//        while responder != nil {
//            print(responder!)
//            responder = responder?.next
//        }
        
        self.view1 = ZGView1(frame: CGRect(x: 0, y: 100, width: SpeedyApp.screenWidth, height: 200))
        view.addSubview(self.view1!)
        
        self.view1?.testBlock = {
            self.title = "你好"
        }
        
        let view2 = ZGView2(frame: CGRect(x: 20, y: 50, width: 100, height: 100))
        view1?.addSubview(view2)
        
        let view3 = ZGView3(frame: CGRect(x: 140, y: 50, width: 100, height: 100))
        view1?.addSubview(view3)
        
        let view4 = ZGView4(frame: CGRect(x: 260, y: 50, width: 100, height: 100))
        view1?.addSubview(view4)
        
        var responder: UIResponder? = view
        while responder != nil {
            print(responder!)
            responder = responder?.next
        }
    }
}

class ZGView1: UIView {
    
    var testBlock: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        XHLogDebug("hitTest - ZGView1")
        self.testBlock?()
        return super.hitTest(point, with: event)
    }
    
}

class ZGView2: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        XHLogDebug("hitTest - ZGView2")
        return super.hitTest(point, with: event)
    }
}

class ZGView3: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        XHLogDebug("hitTest - ZGView3")
        return super.hitTest(point, with: event)
    }
}

class ZGView4: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        XHLogDebug("hitTest - ZGView4")
        return super.hitTest(point, with: event)
    }
}



/*
 描述：
 view1加在ViewController的view上，view2、view3、view4依次添加在view1上；
 
 实验1：点击view1，打印结果如下：
 [01-12 14:03:05]-[DEBUG]-->hitTest - ZGView1
 [01-12 14:03:05]-[DEBUG]-->hitTest - ZGView4
 [01-12 14:03:05]-[DEBUG]-->hitTest - ZGView3
 [01-12 14:03:05]-[DEBUG]-->hitTest - ZGView2
 [01-12 14:03:05]-[DEBUG]-->hitTest - ZGView1
 [01-12 14:03:05]-[DEBUG]-->hitTest - ZGView4
 [01-12 14:03:05]-[DEBUG]-->hitTest - ZGView3
 [01-12 14:03:05]-[DEBUG]-->hitTest - ZGView2

 实验2：点击view2，打印结果如下：
 [01-12 14:03:47]-[DEBUG]-->hitTest - ZGView1
 [01-12 14:03:47]-[DEBUG]-->hitTest - ZGView4
 [01-12 14:03:47]-[DEBUG]-->hitTest - ZGView3
 [01-12 14:03:47]-[DEBUG]-->hitTest - ZGView2
 [01-12 14:03:47]-[DEBUG]-->hitTest - ZGView1
 [01-12 14:03:47]-[DEBUG]-->hitTest - ZGView4
 [01-12 14:03:47]-[DEBUG]-->hitTest - ZGView3
 [01-12 14:03:47]-[DEBUG]-->hitTest - ZGView2
 
 实验3：点击view3，打印结果如下：
 [01-12 14:06:20]-[DEBUG]-->hitTest - ZGView1
 [01-12 14:06:20]-[DEBUG]-->hitTest - ZGView4
 [01-12 14:06:20]-[DEBUG]-->hitTest - ZGView3
 [01-12 14:06:20]-[DEBUG]-->hitTest - ZGView1
 [01-12 14:06:20]-[DEBUG]-->hitTest - ZGView4
 [01-12 14:06:20]-[DEBUG]-->hitTest - ZGView3
 
 
 实验4：点击view4，打印结果如下：
 [01-12 14:06:56]-[DEBUG]-->hitTest - ZGView1
 [01-12 14:06:56]-[DEBUG]-->hitTest - ZGView4
 [01-12 14:06:56]-[DEBUG]-->hitTest - ZGView1
 [01-12 14:06:56]-[DEBUG]-->hitTest - ZGView4
 */

/*
 响应者对象：能处理事件的对象，也就是继承自UIResponder的对象
 作用：能很清楚的看见每个响应者之间的联系，并且可以让一个事件多个对象处理。
 如何判断上一个响应者

 1> 如果当前这个view是控制器的view,那么控制器就是上一个响应者
 2> 如果当前这个view不是控制器的view,那么父控件就是上一个响应者
 响应者链的事件传递过程:

 1>如果当前view是控制器的view，那么控制器就是上一个响应者，事件就传递给控制器；如果当前view不是控制器的view，那么父视图就是当前view的上一个响应者，事件就传递给它的父视图
 2>在视图层次结构的最顶级视图，如果也不能处理收到的事件或消息，则其将事件或消息传递给window对象进行处理
 3>如果window对象也不处理，则其将事件或消息传递给UIApplication对象
 4>如果UIApplication也不能处理该事件或消息，则将其丢弃
 事件处理的整个流程总结：
 　　1.触摸屏幕产生触摸事件后，触摸事件会被添加到由UIApplication管理的事件队列中（即，首先接收到事件的是UIApplication）。
 　　2.UIApplication会从事件队列中取出最前面的事件，把事件传递给应用程序的主窗口（keyWindow）。
 　　3.主窗口会在视图层次结构中找到一个最合适的视图来处理触摸事件。（至此，第一步已完成)
 　　4.最合适的view会调用自己的touches方法处理事件
 　　5.touches默认做法是把事件顺着响应者链条向上抛。
 touches的默认做法：

 #import "WSView.h"
 @implementation WSView
 //只要点击控件,就会调用touchBegin,如果没有重写这个方法,自己处理不了触摸事件
 // 上一个响应者可能是父控件
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 // 默认会把事件传递给上一个响应者,上一个响应者是父控件,交给父控件处理
 [super touchesBegan:touches withEvent:event];
 // 注意不是调用父控件的touches方法，而是调用父类的touches方法
 // super是父类 superview是父控件
 }
 @end
 事件的传递与响应：
 1、当一个事件发生后，事件会从父控件传给子控件，也就是说由UIApplication -> UIWindow -> UIView -> initial view,以上就是事件的传递，也就是寻找最合适的view的过程。

 2、接下来是事件的响应。首先看initial view能否处理这个事件，如果不能则会将事件传递给其上级视图（inital view的superView）；如果上级视图仍然无法处理则会继续往上传递；一直传递到视图控制器view controller，首先判断视图控制器的根视图view是否能处理此事件；如果不能则接着判断该视图控制器能否处理此事件，如果还是不能则继续向上传 递；（对于第二个图视图控制器本身还在另一个视图控制器中，则继续交给父视图控制器的根视图，如果根视图不能处理则交给父视图控制器处理）；一直到 window，如果window还是不能处理此事件则继续交给application处理，如果最后application还是不能处理此事件则将其丢弃

 3、在事件的响应中，如果某个控件实现了touches...方法，则这个事件将由该控件来接受，如果调用了[supertouches….];就会将事件顺着响应者链条往上传递，传递给上一个响应者；接着就会调用上一个响应者的touches….方法

 如何做到一个事件多个对象处理：
 因为系统默认做法是把事件上抛给父控件，所以可以通过重写自己的touches方法和父控件的touches方法来达到一个事件多个对象处理的目的。

 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 // 1.自己先处理事件...
 NSLog(@"do somthing...");
 // 2.再调用系统的默认做法，再把事件交给上一个响应者处理
 [super touchesBegan:touches withEvent:event];
 }

 事件的传递和响应的区别：
 事件的传递是从上到下（父控件到子控件），事件的响应是从下到上（顺着响应者链条向上传递：子控件到父控件。

 作者：VV木公子
 链接：https://www.jianshu.com/p/2e074db792ba
 来源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
