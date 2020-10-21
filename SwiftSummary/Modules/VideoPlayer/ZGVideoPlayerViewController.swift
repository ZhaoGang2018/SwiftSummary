//
//  ZGVideoPlayerViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/9/25.
//  Copyright © 2020 zhaogang. All rights reserved.
//

import UIKit

class ZGVideoPlayerViewController: XHBaseViewController {
    
    var textField: UITextField?
    
    var listTableView: UITableView?
    var videoNames: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fakeNavBar?.isHidden = true
        self.showInputAlert()
    }
    
    // 加载数据
    private func loadData() {
        
        self.videoNames.removeAll()
        self.listTableView?.hideEmptyTipView()
        do {
            let folderPath = XHImageCacheManager.shared.getFolderPath(.UserVideos)
            let array = try FileManager.default.contentsOfDirectory(atPath: folderPath)
            for fileName in array {
                var isDir: ObjCBool = true
                let fullPath = "\(folderPath)/\(fileName)"
                if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                    if isDir.boolValue == false {
                        self.videoNames.append(fileName)
                    } else {
                        let array2 = try FileManager.default.contentsOfDirectory(atPath: fullPath)
                        for fileName2 in array2 {
                            let subFullPath = "\(fullPath)/\(fileName2)"
                            if FileManager.default.fileExists(atPath: subFullPath) {
                                self.videoNames.append("\(fileName)/\(fileName2)")
                            }
                        }
                    }
                }
            }
        } catch {
            XHLogDebug("读取文件错误\(error)")
        }
        
        if self.videoNames.count == 0 {
            self.listTableView?.showEmptyTipView(text: "视频列表是空的", buttonTitle: "重试", isShowButton: true) {[weak self] in
                self?.loadData()
            }
        }
        
        self.listTableView?.pullLoader?.endRefresh()
        self.listTableView?.reloadData()
    }
}

extension ZGVideoPlayerViewController {
    
    private func showInputAlert() {
        UIAlertController.showInputAlert(title: "请输入密码", message: "为了保证用户安全，请您务必输入密码！", buttonTitles: ["取消", "确定"], viewController: self) { (index, _) in
            
            if index == 0 || (index == 1 && self.textField?.text != "Gang25123") {
                self.showInputAlert()
                return
            }
            
            self.buildUI()
            
        } inputHandler: { (textFiled) in
            self.textField = textFiled
            self.textField?.isSecureTextEntry = true
        }
    }
    
    private func buildUI() {
        
        listTableView = UITableView.init(frame: view.bounds, style: .plain)
        listTableView?.delegate = self;
        listTableView?.dataSource = self;
        listTableView?.estimatedRowHeight = 0
        listTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        listTableView?.separatorColor = UIColor.clear
        listTableView?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        listTableView?.contentInset = UIEdgeInsets(top: SpeedyApp.statusBarHeight, left: 0, bottom: SpeedyApp.tabBarBottomHeight, right: 0)
        view.addSubview(listTableView!)
        
        listTableView?.snp.makeConstraints({ (make) in
            make.top.bottom.left.right.equalToSuperview()
        })
        
        listTableView?.setPullLoader(style: .header, onRefresh: { [weak self] (direction) in
            self?.loadData()
        })
        
        self.loadData()
    }
}

extension ZGVideoPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont.Semibold(20)
        cell.textLabel?.textColor = UIColor.white
        cell.tag = indexPath.row
        cell.textLabel?.text = videoNames[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoNames.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let filePath = XHImageCacheManager.shared.getFilePath(self.videoNames[indexPath.row], cacheType: .UserVideos)
        let model = XHPreviewImageOrVideoModel(type: .video, image: nil , imageUrlStr: nil, videoPath: filePath, videoUrlStr: "", placeholderUrlStr: "", placeholderImage: nil)
        
        let browserVC = XHPreviewImageOrVideoViewController(dataSource: [model], currentIndex: 0) { (index) -> (UIView?, UIImage?, CGRect) in
            
            return (self.view, nil, self.view.bounds)
        }
        
        browserVC.show(method: .present(fromVC: self, embed: nil))
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UIAlertController.showAlert(title: "确定要删除它吗？", message: "删除后就不能再看了", buttonTitles: ["再想想", "确定"], viewController: self) { (index, _) in
                if index == 1 {
                    let filePath = XHImageCacheManager.shared.getFilePath(self.videoNames[indexPath.row], cacheType: .UserVideos)
                    SpeedyFileManager.removeFile(at: filePath)
                    self.loadData()
                }
            }
        }
    }
}
