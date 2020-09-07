//
//  XHBasePlainTableViewController.swift
//  XCamera
//
//  Created by 管理员 Cc on 2020/7/13.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit


public let XHNomalTableViewCellHeight76:CGFloat = 76

class XHBasePlainTableViewController: XHBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView:UITableView = {
        
        let _tableView =  getTableView()
        
        _tableView.separatorStyle = .none
        _tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: -1, width: SpeedyApp.screenWidth, height: 1))
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.backgroundColor = UIColor.white
        
        return _tableView
    }()
    
    func getTableView()->UITableView{
        return UITableView.init(frame: CGRect.init(x: 0, y: SpeedyApp.statusBarAndNavigationBarHeight - 1, width: SpeedyApp.screenWidth, height: SpeedyApp.screenHeight), style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(SpeedyApp.statusBarAndNavigationBarHeight)
        }
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  44
    }
}
    

class XHBaseGroupTableViewController: XHBasePlainTableViewController {

    override func getTableView()->UITableView{
        return UITableView.init(frame: CGRect.init(x: 0, y: SpeedyApp.statusBarAndNavigationBarHeight - 1, width: SpeedyApp.screenWidth, height: SpeedyApp.screenHeight), style: .grouped)
    }
}
