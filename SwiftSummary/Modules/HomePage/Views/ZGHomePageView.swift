//
//  ZGHomePageView.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/4/17.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

class ZGHomePageView: UIView {
    
    static let cellSelectSignal = "cellSelectSignal"
    
    var listTableView : UITableView?
    var headerView : UIView?
    var footerView : UIView?
    
    var items: [ZGFeatureItemType] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        self.backgroundColor = UIColor.clear
        buildTableView()
    }
    
    func configData(list: [ZGFeatureItemType]) {
        items.removeAll()
        for model in list {
            items.append(model)
        }
        self.listTableView?.reloadData()
    }
}

extension ZGHomePageView : UITableViewDelegate, UITableViewDataSource {
    
    private func buildTableView() {
        // 初始化表格
        listTableView = UITableView.init(frame: self.bounds, style: .plain)
        listTableView?.delegate = self;
        listTableView?.dataSource = self;
        listTableView?.estimatedRowHeight = 0
        listTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "HomePageTableViewCell")
        listTableView?.separatorColor = UIColor.clear
        listTableView?.backgroundColor = UIColor.clear//UIColor.fromHex("#EFEFF4")
        self.addSubview(listTableView!)
        
        listTableView?.snp.makeConstraints({ (make) in
            make.left.top.width.height.equalToSuperview()
        })
        
        listTableView?.tableHeaderView = headerView
        listTableView?.tableFooterView = footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageTableViewCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].rawValue
        _ = cell.contentView.addLine(position: .top, color: UIColor.lineColor(), ply: 1, leftPadding: 0, rightPadding: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.sendSignal(name: ZGHomePageView.cellSelectSignal, parameter: items[indexPath.row], tag: indexPath.row)
    }
}

