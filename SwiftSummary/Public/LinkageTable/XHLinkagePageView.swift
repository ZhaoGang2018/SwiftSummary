//
//  XHBaseLinkagePageView.swift
//  XCamera
//
//  Created by 赵刚 on 2020/6/10.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

class XHLinkagePageView: UIView {
    
    var tableView: UITableView?
    var canScroll: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        
        self.tableView = UITableView(frame: self.bounds, style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView?.backgroundColor = UIColor.fromHex("#EFEFF4")
        self.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints({ (make) in
            make.top.bottom.left.right.equalToSuperview()
        })
    }
}

extension XHLinkagePageView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.viewFrameHeight + 5.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView != self.tableView {
            return
        }
        
        if self.canScroll == false {
            self.tableView?.contentOffset = CGPoint.zero
        }
        
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            self.tableView?.contentOffset = CGPoint.zero
            self.canScroll = false
            
//            NotificationCenter.default.post(name: XHNotification.OutermostTableViewDidCanScrollNotification, object: nil)
        }
        self.tableView?.showsVerticalScrollIndicator = self.canScroll
    }
    
    func pagViewCanScroll(isScroll: Bool) {
        self.tableView?.showsVerticalScrollIndicator = isScroll
        self.canScroll = isScroll
        if isScroll == false {
            self.tableView?.contentOffset = CGPoint.zero
        }
    }
}
