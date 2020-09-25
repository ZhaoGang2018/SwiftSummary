//
//  XHPreviewTeamPhotoViewController.swift
//  XCamera
//
//  Created by jing_mac on 2020/5/28.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

class XHPreviewTeamPhotoViewController: XHPreviewImageOrVideoViewController {
    
    /*
    
    var place: String = "" // 预览位置
    var groupId: String? // 团队id
    var groupRole: Int? // 当前用户在团队的角色 0 普通员工；1 主管理员；2 管理员
    var isTeamAlbum: Bool = false // 是不是团队相册
    
    private var locationBtn: UIButton?
    private var deleteBtn: UIButton?
    private var downloadBtn: UIButton?
    
    private var headImageView: UIImageView?
    private var nicknameLabel: UILabel?
    
    // vip引导，用于添加按钮（自己添加）
    open var vipGuideView: UIView?
    
    // 用户信息的view（自己添加）
    open var userInfoView: UIView?
    
    // 底部的view，用于添加按钮（自己添加）
    open var bottomCustomView: UIView?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        if self.player?.isFullScreen == true {
            return .landscape
        }
        return .portrait
    }
    
    deinit {
        XHLogDebug("deinit - [图片或视频预览调试] - XHPreviewTeamPhotoViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let topView = self.vipGuideView {
            view.bringSubviewToFront(topView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        self.updateButtonStatus()
        
        self.didChangedPageIndex = { [weak self] index in
            if let weakSelf = self, let currentModel = weakSelf.dataSource[index] as? XHPreviewTeamPhotoItem {
                
                let fileType = (currentModel.mediaType == 1) ? "video" : "photo"
                Report.workgroup_album_click(clickItem: "PreOrNext", place: weakSelf.place, hasNavigationMap: nil,role: weakSelf.groupRole, ownerId: weakSelf.getAuthUserId(), fileType: fileType)
            }
            self?.updateButtonStatus()
        }
    }
    
    // 设置cell的类型
    override func setCellClass(at index: Int) -> JXPhotoBrowserCell.Type {
        
        let currentModel = self.dataSource[index]
        if currentModel.type == .image {
            return XHPreviewTeamPhotoCell.self
        } else {
            return XHPreviewTeamVideoCell.self
        }
    }
    
    /// Cell将显示 9d2edccb28aac8c4fedbfcb463a90b27.mp4
    override func cellWillAppear(_ cell: JXPhotoBrowserCell, index: Int) {
        XHLogDebug("[图片或视频预览调试] - Cell将显示 - index:[\(index)]")
        if let videoIndex = self.currentPlayIndex, videoIndex == index {
            return
        }
        
        if let videoCell = cell as? XHPreviewTeamVideoCell,
            let model = self.dataSource[index] as? XHPreviewTeamPhotoItem,
            let tempStr = model.videoURL?.urlPercentEncoding,
            let url = URL(string: tempStr), let proxyURL = XHKTVHTTPCacheManager.getProxyURL(url) {
            
            self.addPlayer(videoCell.imageView, videoUrl: proxyURL, coverURLStr: model.largeUrl ?? "", coverImage: model.placeholderImage, playIndex: index)
        } else {
            self.stopPlayVideo()
        }
    }
    
    /// Cell将消失
    override func cellWillDisappear(_ cell: JXPhotoBrowserCell, index: Int) {
        XHLogDebug("[图片或视频预览调试] - Cell将消失 - index:[\(index)]")
        if let playIndex = self.currentPlayIndex, playIndex == index {
            self.stopPlayVideo()
        }
    }
    
    override func configData(_ context: XHPreviewImageOrVideoViewController.ReloadCellContext) {
        
//        XHLogDebug("[图片或视频预览调试] - 填充数据 - index:[\(context.index)] - currentIndex:[\(context.currentIndex)]")
        if self.dataSource.count == 0 || context.index >= self.dataSource.count {
            return
        }
        
        guard let currentModel = self.dataSource[context.index] as? XHPreviewTeamPhotoItem else {
            return
        }
        
        if currentModel.mediaType == 1 {
            // 视频
            if let cell = context.cell as? XHPreviewTeamVideoCell {
                cell.imageView.setImage(with: currentModel.largeUrl, defaultImage: currentModel.placeholderImage, complete: { [weak cell] (image, url) in
                    cell?.setNeedsLayout()
                })
            }
        } else {
            // 图片
            if let cell = context.cell as? XHPreviewTeamPhotoCell {
                cell.imageView.setImage(with: currentModel.largeUrl, defaultImage: currentModel.placeholderImage, complete: { [weak cell] (image, url) in
                    cell?.setNeedsLayout()
                })
            }
        }
    }
    
    override func dismiss() {
        if pageIndex < self.dataSource.count, let currentModel = self.dataSource[pageIndex] as? XHPreviewTeamPhotoItem {
            let fileType = (currentModel.mediaType == 1) ? "video" : "photo"
            Report.workgroup_album_click(clickItem: "clickClose", place: place, hasNavigationMap: nil,role: self.groupRole, ownerId: self.getAuthUserId(), fileType: fileType)
        }
        closeSyncOriginalImageTip()
        
        vipGuideView?.removeFromSuperview()
        userInfoView?.removeFromSuperview()
        bottomCustomView?.removeFromSuperview()
        super.dismiss()
    }
    
    // 点击视频播放右下角的关闭
    override func closeVideoAction() {
        if dataSource.count > self.pageIndex, self.pageIndex >= 0, let currentModel = dataSource[self.pageIndex] as? XHPreviewTeamPhotoItem {
            let fileType = (currentModel.mediaType == 1) ? "video" : "photo"
            Report.workgroup_album_click(clickItem: "videoCloseButton", place: place, hasNavigationMap: nil,role: self.groupRole, ownerId: self.getAuthUserId(), fileType: fileType)
        }
        self.dismiss()
    }
    
    // 点击视频中心的播放
    override func centerPlayButtonAction() {
        if dataSource.count > self.pageIndex, self.pageIndex >= 0, let currentModel = dataSource[self.pageIndex] as? XHPreviewTeamPhotoItem {
            let fileType = (currentModel.mediaType == 1) ? "video" : "photo"
            Report.workgroup_album_click(clickItem: "videoPlay", place: place, hasNavigationMap: nil,role: self.groupRole, ownerId: self.getAuthUserId(), fileType: fileType)
        }
    }
    
    // MARK: - 删除按钮的点击方法
    @objc private func deleteButtonAction() {
        
        func complete(_ model: XHNetworkResponseBaseResult?, error: Error?, groupId: String) {
            if let tempM = model, let status = tempM.status {
                if status == 0 {
                    self.showSuccessToast("删除成功")
                    self.refresh()
                } else {
                    XHErrorCodeManager.shared.handleErrorCode(status, serverMsg:tempM.msg, currentVC: self, groupId: groupId)
                }
            } else {
                showNetError()
            }
        }
        
        func delete(_ currentItem: XHPreviewTeamPhotoItem){
            
            let currentUserId = XHUserManager.shared.userModel.userId
            let currentPhotoId = Int(currentItem.photoId ?? "0") ?? 0
            
            if currentUserId == currentItem.authorUserId {
                self.networkAPI.workgroupuUserDeletePhoto(user_id: currentUserId, group_id: currentItem.groupId ?? "", photo_id: currentPhotoId) { (error, model) in
                    complete(model, error: error, groupId: currentItem.groupId ?? "")
                }
            } else {
                // 管理员删除其他成员的照片
                self.networkAPI.adminDeleteUserPhoto(user_id: currentUserId, group_id: currentItem.groupId ?? "", photo_id: currentPhotoId) { (error, model) in
                    // "status": 0, // 0 成功; -3 user_id未进群; -5 photo_id不存在; -9 签名验证失败; -10 无管理权限
                    complete(model, error: error, groupId: currentItem.groupId ?? "")
                }
            }
        }
        
        guard let currentItem = dataSource[self.pageIndex] as? XHPreviewTeamPhotoItem else {
            return
        }
               
        let fileType = (currentItem.mediaType == 1) ? "video" : "photo"
        Report.workgroup_album_click(clickItem: "Delete", place: place, hasNavigationMap: nil,role: self.groupRole, ownerId: self.getAuthUserId(), fileType: fileType)
        
        let alertTitle = (currentItem.mediaType == 1) ? "要从团队中删除这个视频吗？" : "要从团队中删除这张照片吗？"
        let alertContent = (currentItem.mediaType == 1) ? "团队中的视频，不会占用手机的存储空间" : "团队中的照片，不会占用手机的存储空间"
        
        //  let tipText = self.isTeamAlbum ? "要从团队中彻底删除此照片吗？" : "要删除这张照片吗？"
        UIAlertController.showAlert(title: alertTitle, message: alertContent, buttonTitles: ["取消", "删除"], viewController: self) { (index, alert) in
            if index == 1 {
                delete(currentItem)
            }
        }
    }
    
    // 刷新数据
    private func refresh(){
        // 容错处理，防止崩溃
        if self.pageIndex >= self.dataSource.count {
            return
        }
        
        if let model = self.dataSource[self.pageIndex] as? XHPreviewTeamPhotoItem {
            NotificationCenter.default.post(name: XHNotification.UserDidDeletePhotos, object: nil, userInfo: ["deletePhotoIDs" : [model.photoId]])
        }
        self.stopPlayVideo()
        self.dataSource.remove(at: self.pageIndex)
        self.reloadData()
        
        if self.dataSource.count == 0 {
            self.dismiss()
        } else {
            self.updateButtonStatus()
        }
    }
    
    // MARK: - 下载图片
    @objc private func downloadButtonAction() {
        
        if dataSource.count > self.pageIndex, self.pageIndex >= 0, let currentModel = dataSource[self.pageIndex] as? XHPreviewTeamPhotoItem {
            
            let fileType = (currentModel.mediaType == 1) ? "video" : "photo"
            Report.workgroup_album_click(clickItem: "download", place: place, hasNavigationMap: nil,role: self.groupRole, ownerId: self.getAuthUserId(), fileType: fileType)
            
            if currentModel.mediaType == 1 {
                let urlStr = currentModel.videoURL ?? ""
                let fileName = urlStr.md5() + ".mp4"
                let filePath = XHImageCacheManager.shared.getFilePath(fileName, cacheType: .UserVideos)
                
                UIApplication.shared.keyWindow?.showLoading(tipText: "正在下载", isShowCloseBtn: true, cancelHandler: nil)
                _ = XHAlamofireDownloader.shared.download(urlStr, destinationPath: filePath, progress: { (_, _, _) in
                    
                }) { [weak self] (isSuccess, error, msg) in
                    UIApplication.shared.keyWindow?.hiddenLoading()
                    if isSuccess {
                        let videoInfoM = XHSavePhotoFileModel(isVideo: true, fileName: fileName, filePath: filePath, fileData: nil, delegate: self)
                        XHSavePhotoToAlbumManager.shared.startSavePhotoOrVideo(videoInfoM)
                    } else {
                        self?.showToast("保存失败")
                    }
                }
            } else {
                let urlStr = currentModel.largeUrl ?? ""
                XHImageCacheManager.downloadImage(url: urlStr) { (image, data, error) in
                    if let tempData = data {
                        XHSavePhotoToAlbumManager.shared.savePhotoToAlbum(imageData: tempData, delegate: self)
                    }
                }
            }
        }
    }
    
    // MARK: - 拍摄地点按钮的点击方法
    @objc private func mapNavigationTapAction() {
        if self.pageIndex < self.dataSource.count, let item = self.dataSource[self.pageIndex] as? XHPreviewTeamPhotoItem {
            
            let hasNavigationMap =  XHMapManager.shared.hasNavigationMap
            let fileType = (item.mediaType == 1) ? "video" : "photo"
            Report.workgroup_album_click(clickItem: "locationNavigate", place: place, hasNavigationMap: hasNavigationMap,role: self.groupRole, ownerId: self.getAuthUserId(), fileType: fileType)
            
            XHMapManager.shared.showMapSheet(longitudeStr: item.longitude, latitudeStr: item.latitude, address: nil, location_type: item.locationType, viewController: self)
        }
    }
    
    @objc private func settingButtonAction() {
        Report.workgroup_photo_preview_sync_full_image_guid_click(clickItem: "goSet")
        closeSyncOriginalImageTip()
        
        if let _ = self.groupRole {
            self.goSeting()
        } else {
            if let groupID = self.groupId {
                self.showLoading()
                XHTeamManager.shared.getGroupRole(groupId: groupID) { [weak self] (role) in
                    self?.hiddenLoading()
                    self?.groupRole = role
                    self?.goSeting()
                }
            }
        }
    }
    
    func goSeting() {
        if self.groupRole == 1 || self.groupRole == 2 {
            if XHAPPConfigureManager.shared.isReviewMode(){
                let urlStr = "https://h5.xhey.top/coming-soon"
                let vc = XHWebViewController(urlString: urlStr, parameters: ["groupId": self.groupId ?? ""])
                self.pushOrPresentViewController(vc)
            } else {
                if XHNetworkStatusManager.shared.isNetworkAvailable == false {
                    // 网络不可用
                    self.showToast("网络不给力，请检查网络连接")
                    return
                }
                
                if let groupID = self.groupId, let groupModel = XHUserManager.shared.getSyncGroupModel(groupID) {
                    let vc = UIStoryboard(name: "TeamVIP", bundle: .main).instantiateViewController(withIdentifier: "XHTeamSyncOriginalPhotoSettingViewController") as! XHTeamSyncOriginalPhotoSettingViewController
                    let singleGroupModel = SingleWorkGroupModel()
                    singleGroupModel.group_id = groupID
                    singleGroupModel.group_name = groupModel.group_name
                    singleGroupModel.group_color = groupModel.group_color
                    singleGroupModel.isHDEnable = groupModel.isHDEnable
                    vc.group = singleGroupModel
                    
                    self.pushOrPresentViewController(vc)
                }
            }
        } else {
            UIAlertController.showAlert(title: "请联系管理员开启同步原图", message: nil, buttonTitles: ["确定"], viewController: self, onSelect: nil)
        }
    }
    
    // 忽略
    @objc private func ignoreButtonAction() {
        closeSyncOriginalImageTip()
        Report.workgroup_photo_preview_sync_full_image_guid_click(clickItem: "ignore")
    }
    
    // 跳转到用户主页
    @objc private func toUserHomePage() {
        
        if let currentModel = self.dataSource[pageIndex] as? XHPreviewTeamPhotoItem,
            let userId = currentModel.authorUserId, userId.count > 0,
            let groupId = currentModel.groupId, groupId.count > 0 {
            
            let fileType = (currentModel.mediaType == 1) ? "video" : "photo"
            Report.workgroup_album_click(clickItem: "avatarNickname", place: self.place, hasNavigationMap: nil,role: self.groupRole, ownerId: self.getAuthUserId(), fileType: fileType)
            
            let userModel = WorkgroupUserModel(groupId: groupId, userId: userId, nickname: currentModel.authorNickname ?? "", headimgurl: currentModel.authorHeadImage ?? "", groupRole: currentModel.groupRole)
            
            let vc = XHUserHomepageViewController.init(userModel: userModel, default_page_start_time: "")
            let nav = XHBaseNavigationController(rootViewController: vc)
            nav.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .left) , dismissing: .uncover(direction: .right))
            nav.hero.isEnabled = true
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // 关闭同步原图的提示
    private func closeSyncOriginalImageTip() {
        if let _ = self.vipGuideView {
            UserDefaults.standard.set(true, forKey: XHGlobalConstant.UdKey.uIsShowSyncOriginalImageTipInPreview)
            self.vipGuideView?.isHidden = true
            self.vipGuideView?.removeFromSuperview()
            self.vipGuideView = nil
        }
    }
    
    // 更新按钮的状态
    func updateButtonStatus() {
        
        if pageIndex >= self.dataSource.count {
            return
        }
        
        if let currentModel = self.dataSource[pageIndex] as? XHPreviewTeamPhotoItem {
            
            if self.isTeamAlbum {
                self.nicknameLabel?.text = currentModel.authorNickname
                self.headImageView?.setImage(with: currentModel.authorHeadImage)
            }
            
            let isMyPhoto = XHUserManager.shared.isSelf(currentModel.authorUserId ?? "")
            let hasPerm = currentModel.deletePermission ?? false
            
            if isMyPhoto || hasPerm {
                deleteBtn?.isHidden = false
            } else {
                deleteBtn?.isHidden = true
            }
        }
    }
}

extension XHPreviewTeamPhotoViewController {
    
    private func buildUI() {
        
        self.pageIndicator = XHPreviewTeamPhotoNumberPageIndicator()
        if self.isTeamAlbum {
            self.buildUserInfoView()
            self.pageIndicator?.alpha = 0 // 团队相册的时候不展示页码
        }
        
        let isShowed = UserDefaults.standard.bool(forKey: XHGlobalConstant.UdKey.uIsShowSyncOriginalImageTipInPreview)
        if isShowed == false {
            self.buildVipGuideView()
        }
        
        self.buildBottomView()
    }
    
    private func buildUserInfoView() {
        
        self.userInfoView = UIView(backgroundColor: UIColor.fromHex("#2F2F2F"), cornerRadius: 5)
        _ = self.userInfoView?.addTapGestureRecognizer(target: self, action: #selector(toUserHomePage))
        view.addSubview(self.userInfoView!)
        
        let statusHeight = SpeedyApp.statusBarHeight
        self.userInfoView?.snp.makeConstraints({ (make) in
            make.left.equalTo(12)
            make.top.equalTo(statusHeight + 12)
            make.right.lessThanOrEqualTo(-10)
            make.height.equalTo(44)
        })
        
        self.headImageView = UIImageView(backgroundColor: UIColor.white, cornerRadius: 3)
        self.userInfoView?.addSubview(self.headImageView!)
        self.headImageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(7)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        })
        
        self.nicknameLabel = UILabel(text: "", textColor: UIColor.white, textFont: UIFont.Semibold(18))
        self.userInfoView?.addSubview(self.nicknameLabel!)
        self.nicknameLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.headImageView!.snp.right).offset(10)
            make.right.equalTo(-10)
            make.top.height.equalToSuperview()
        })
    }
    
    private func buildVipGuideView() {
        self.vipGuideView = UIView(backgroundColor: UIColor.white, cornerRadius: 8)
        self.vipGuideView?.backgroundColor = UIColor.white
        view.addSubview(self.vipGuideView!)
        self.vipGuideView?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(SpeedyApp.statusBarHeight + 70)
            make.top.equalTo(-10)
        })
        
        let tipLabel = UILabel(text: "照片不够清晰？试试同步原图", textColor: UIColor.fromHex("#47484E"), textFont: UIFont.regular(17), textAlignment: .left, numberLines: 0)
        vipGuideView?.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(SpeedyApp.statusBarHeight + 20)
            make.bottom.equalTo(-2)
            make.left.equalTo(12)
            make.right.equalTo(-156)
        }
        
        let settingBtn = UIButton(title: "去设置", titleColor: UIColor.white, titleFont: UIFont.Semibold(14), backgroundColor: UIColor.blueColor_xh(), cornerRadius: 4)
        settingBtn.addTarget(self, action: #selector(settingButtonAction), for: .touchUpInside)
        vipGuideView?.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { (make) in
            make.width.equalTo(74)
            make.height.equalTo(32)
            make.bottom.equalTo(-14)
            make.right.equalTo(-10)
        }
        
        let ignoreBtn = UIButton(title: "忽略", titleColor: UIColor.fromHex("#83838C"), titleFont: UIFont.Semibold(14), backgroundColor: UIColor.fromHex("#E6E9ED"), cornerRadius: 4)
        ignoreBtn.addTarget(self, action: #selector(ignoreButtonAction), for: .touchUpInside)
        vipGuideView?.addSubview(ignoreBtn)
        ignoreBtn.snp.makeConstraints { (make) in
            make.width.equalTo(46)
            make.height.equalTo(32)
            make.bottom.equalTo(-14)
            make.right.equalTo(settingBtn.snp.left).offset(-6)
        }
    }
    
    private func buildBottomView() {
        self.bottomCustomView = UIView()
        view.addSubview(bottomCustomView!)
        bottomCustomView?.snp.makeConstraints({ (make) in
            make.left.equalTo(60)
            make.right.equalToSuperview()
            make.bottom.equalTo(-SpeedyApp.tabBarBottomHeight - 12)
            make.height.equalTo(40)
        })
        
        downloadBtn = UIButton(imageName: "gallery_download")
        downloadBtn?.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
        bottomCustomView?.addSubview(downloadBtn!)
        downloadBtn!.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        
        deleteBtn = UIButton(imageName: "gallery_del")
        deleteBtn?.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        bottomCustomView?.addSubview(deleteBtn!)
        deleteBtn!.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.equalTo(downloadBtn!.snp.left).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        locationBtn = UIButton(imageName: "gallery_show_loc")
        locationBtn?.addTarget(self, action: #selector(mapNavigationTapAction), for: .touchUpInside)
        bottomCustomView?.addSubview(locationBtn!)
        locationBtn!.snp.makeConstraints { (make) in
            make.width.equalTo(84)
            make.height.equalTo(40)
            make.right.equalTo(deleteBtn!.snp.left).offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    func getAuthUserId() -> String? {
        //2.9.60版本修复bugtag bug,任务id= 14735-1
        let _dataSource = self.dataSource
        if pageIndex < _dataSource.count, let currentModel = _dataSource[pageIndex] as? XHPreviewTeamPhotoItem {
            return currentModel.authorUserId
        }
        return nil
    }
    
}

// MARK: - XHSavePhotoToAlbumManagerDelegate
extension XHPreviewTeamPhotoViewController: XHSavePhotoToAlbumManagerDelegate {
    func savePhotoSuccess(model: XHSavePhotoFileModel) {
        let name = model.isVideo ? "视频" : "图片"
        self.view.showSuccessToast("\(name)保存成功")
    }
    
    func savePhotoFailure(model: XHSavePhotoFileModel, error: Error?) {
        
        let name = model.isVideo ? "视频" : "图片"
        let tipText = error?.localizedDescription ?? "\(name)保存失败"
        XHLogDebug("照片保存失败 - [\(tipText)]")
        self.view.showSuccessToast("\(name)保存失败")
    }
 */
}
