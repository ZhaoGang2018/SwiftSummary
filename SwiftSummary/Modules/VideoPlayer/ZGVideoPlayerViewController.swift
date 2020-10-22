//
//  ZGVideoPlayerViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/9/25.
//  Copyright © 2020 zhaogang. All rights reserved.
//

import UIKit

class ZGVideoPlayerModel: NSObject {
    var folderName: String = ""
    var fileNames: [String] = []
    
    convenience init(folderName: String, fileNames: [String]) {
        self.init()
        self.folderName = folderName
        self.fileNames = fileNames
    }
}

class ZGVideoPlayerViewController: XHBaseViewController {
    
    var textField: UITextField?
    
    var listTableView: UITableView?
    var videoModels: [ZGVideoPlayerModel] = []
    
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
        
        self.videoModels.removeAll()
        self.listTableView?.hideEmptyTipView()
        do {
            let rootFolderPath = XHImageCacheManager.shared.getFolderPath(.UserVideos)
            let rootArray = try FileManager.default.contentsOfDirectory(atPath: rootFolderPath)
            
            let otherModel = ZGVideoPlayerModel(folderName: "", fileNames: [])
            
            for fileName in rootArray {
                var isDir: ObjCBool = true
                let filePath = "\(rootFolderPath)/\(fileName)"
                if FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir) {
                    if isDir.boolValue == false {
                        otherModel.fileNames.append(fileName)
                    } else {
                        let currentModel = ZGVideoPlayerModel(folderName: fileName, fileNames: [])
                        let array2 = try FileManager.default.contentsOfDirectory(atPath: filePath)
                        for fileName2 in array2 {
                            let subFullPath = "\(filePath)/\(fileName2)"
                            if FileManager.default.fileExists(atPath: subFullPath) {
                                currentModel.fileNames.append(fileName2)
                            }
                        }
                        
                        self.videoModels.append(currentModel)
                    }
                }
            }
            
            if otherModel.fileNames.count > 0 {
                self.videoModels.append(otherModel)
            }
            
        } catch {
            XHLogDebug("读取文件错误\(error)")
        }
        
        if self.videoModels.count == 0 {
            self.listTableView?.showEmptyTipView(text: "视频列表是空的", buttonTitle: "重试", isShowButton: true) {[weak self] in
                self?.loadData()
            }
        } else {
            for model in self.videoModels {
                model.fileNames = model.fileNames.sorted()
            }
            
            videoModels = videoModels.sorted(by: { (model1, model2) -> Bool in
                model1.folderName < model2.folderName
            })
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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        listTableView = UITableView.init(frame: view.bounds, style: .plain)
        listTableView?.delegate = self;
        listTableView?.dataSource = self;
        listTableView?.estimatedRowHeight = 0
        listTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        listTableView?.separatorColor = UIColor.clear
        listTableView?.backgroundColor = UIColor.clear //UIColor.black.withAlphaComponent(0.7)
        view.addSubview(listTableView!)
        
        listTableView?.snp.makeConstraints({ (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-SpeedyApp.tabBarBottomHeight)
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
        cell.textLabel?.text = videoModels[indexPath.section].fileNames[indexPath.row]
        cell.selectionStyle = .none
        _ = cell.contentView.addLine(position: .bottom, color: UIColor.lineColor(), ply: 1, leftPadding: 0, rightPadding: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoModels[section].fileNames.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return videoModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.videoModels[section].folderName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let filePath = getFilePath(self.videoModels[indexPath.section], row: indexPath.row)
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
                    let filePath = self.getFilePath(self.videoModels[indexPath.section], row: indexPath.row)
                    SpeedyFileManager.removeFile(at: filePath)
                    self.loadData()
                }
            }
        }
    }
    
    // 获取文件路径
    private func getFilePath(_ model: ZGVideoPlayerModel, row: Int) -> String {
        
        let rootFolderPath = XHImageCacheManager.shared.getFolderPath(.UserVideos)
        let folderName = model.folderName
        let fileName = model.fileNames[row]
        
        var filePath = "\(rootFolderPath)/\(fileName)"
        if folderName.count > 0 {
            filePath = "\(rootFolderPath)/\(folderName)/\(fileName)"
        }
        
        return filePath
    }
    
}

