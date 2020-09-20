//
//  XHVideoCustomControlView.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/8.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

protocol XHVideoControlGestureDelegate: class {
    // 单击手势
    func singleTapGesture()
    func closeFullScreen()
}

class XHVideoCustomControlView: UIView {
    
    weak var delegate: XHVideoControlGestureDelegate?
    
    weak var player: ZFPlayerController?
    /// 控制层自动隐藏的时间，默认2.5秒
    var autoHiddenTimeInterval: TimeInterval = 2.5
    /// 控制层显示、隐藏动画的时长，默认0.25秒
    var autoFadeTimeInterval: TimeInterval = 0.25
    /// 顶部工具栏
    var topToolView = UIView()
    // 顶部的返回按钮
    var closeFullScreenBtn = UIButton()
    /// 标题
//    var titleLabel = UILabel()
    /// 底部工具栏
    var bottomToolView = UIView()
    /// 底部工具栏阴影
    var bottomToolViewBgLayer = CAGradientLayer()
    // 小的播放或暂停的按钮
    var smallPlayOrPauseBtn = UIButton()
    /// 播放的当前时间
    var currentTimeLabel = UILabel()
    /// 滑杆
    var slider = ZFSliderView()
    /// 视频总时间
    var totalTimeLabel = UILabel()
    /// 全屏按钮
    var fullScreenBtn = UIButton()
    // 关闭按钮
    var closeBtn = UIButton()
    /// 播放或暂停按钮
    var pauseBtn = UIButton()
    var controlViewAppeared: Bool = false // 是否正在显示
    /// 加载loading
    var activity = ZFSpeedLoadingView()
    /// 封面图
    var coverImageView = UIImageView()
    
    // 是否正在播放
    var isPlaying: Bool {
        if let tempPlayer = self.player {
            return tempPlayer.currentPlayerManager.isPlaying
        }
        return false
    }
    
    // 能否自动隐藏，用于解决滑动进度条的时候也会隐藏的问题
    var canAutoHide: Bool = true
    
    // 正在自动隐藏中
    var isAutoHiding: Bool = false
    
    // 关闭按钮的点击事件
    var closeHandler: SpeedyCommonHandler?
    
    // 重试
    var retryHandler: SpeedyCommonHandler?
    
    // 中心播放按钮的点击
    var centerPlayHandler: SpeedyCommonHandler?
    
    deinit {
        XHLogDebug("deinit - [图片或视频预览调试] - XHVideoCustomControlView")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        buildUI()
        self.resetControlView()
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     设置标题、封面、全屏模式
     
     @param title 视频的标题
     @param coverUrl 视频的封面，占位图默认是灰色的
     @param fullScreenMode 全屏模式
     */
    func showTitle(coverURLString: String, coverImage: UIImage?) {
        
        self.resetControlView()
        self.layoutIfNeeded()
        self.setNeedsLayout()
        
        self.player?.currentPlayerManager.view.coverImageView.setImageWithURLString(coverURLString, placeholder: coverImage)
        self.showControlView(true)
    }
    
    // MARK: - 响应事件action
    @objc func playPauseButtonClickAction(sender: UIButton) {
        self.centerPlayHandler?()
        self.playOrPause()
    }
    
    @objc func fullScreenButtonClickAction(sender: UIButton) {
        let isFull = !(self.player?.isFullScreen ?? true)
        self.player?.enterFullScreen(isFull, animated: true)
    }
    
    /// 根据当前播放状态取反
    func playOrPause() {
        
        guard let currentPlayer = self.player else {
            return
        }
        
        if self.isPlaying {
            currentPlayer.currentPlayerManager.pause()
            pauseBtn.isHidden = false
            smallPlayOrPauseBtn.isSelected = false
            self.showControlView(false)
            self.canAutoHide = false
        } else {
            currentPlayer.currentPlayerManager.play()
            pauseBtn.isHidden = true
            smallPlayOrPauseBtn.isSelected = true
            self.canAutoHide = true
            self.autoHideControlView()
        }
    }
    
    // 关闭按钮的点击方法
    @objc func closeButtonAction() {
        self.closeHandler?()
    }
    
    @objc func closeFullScreenAction() {
        self.player?.enterFullScreen(false, animated: true)
    }
}

extension XHVideoCustomControlView {
    private func buildUI() {
        
        buildTopToolView()
        buildBottomToolView()
        
        pauseBtn.image = UIImage(named: "icon_play_60pt")
        self.pauseBtn.addTarget(self, action: #selector(playPauseButtonClickAction(sender:)), for: .touchUpInside)
        self.addSubview(pauseBtn)
        pauseBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(60.0)
            make.centerX.centerY.equalToSuperview()
        }
        
        coverImageView = UIImageView()
        coverImageView.isUserInteractionEnabled = true
        coverImageView.contentMode = .scaleAspectFit
        self.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.width.height.equalToSuperview()
        }
        
        activity = ZFSpeedLoadingView()
        self.addSubview(activity)
        activity.snp.makeConstraints { (make) in
            make.width.height.equalTo(80.0)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // 顶部的工具栏
    private func buildTopToolView() {
        
        topToolView = UIView()
        self.addSubview(topToolView)
        topToolView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(SpeedyApp.statusBarAndNavigationBarHeight)
        }
        topToolView.isHidden = true
        
        closeFullScreenBtn = UIButton(imageName: "btn_back_on_dark")
        closeFullScreenBtn.addTarget(self, action: #selector(closeFullScreenAction), for: .touchUpInside)
        topToolView.addSubview(closeFullScreenBtn)
        closeFullScreenBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(4)
            make.bottom.equalTo(-2)
            make.width.height.equalTo(40)
        })
        
        /*
        titleLabel = UILabel(text: "", textColor: UIColor.white, textFont: UIFont.regular(15), textAlignment: .center)
        topToolView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(44)
            make.right.equalTo(-44)
            make.height.equalTo(22.0)
            make.bottom.equalTo(-11.0)
        })
        titleLabel.isHidden = true
 */
        
        // 添加阴影
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.frame = CGRect(x: 0, y: 0, width: SpeedyApp.screenHeight, height: SpeedyApp.statusBarAndNavigationBarHeight)//topToolView.bounds
        bgLayer1.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer1.endPoint = CGPoint(x: 1, y: 1)
        topToolView.layer.addSublayer(bgLayer1)
    }
    
    // 底部的
    private func buildBottomToolView() {
        
        bottomToolView = UIView()
        self.addSubview(bottomToolView)
        bottomToolView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(56.0 + 52.0 + SpeedyApp.tabBarBottomHeight)
        }
        
        smallPlayOrPauseBtn.setBtnImage(normal: "ico_progress_bar_play", selected: "ico_progress_bar_time_out", highlighted: "ico_progress_bar_time_out")
        smallPlayOrPauseBtn.addTarget(self, action: #selector(playPauseButtonClickAction(sender:)), for: .touchUpInside)
        bottomToolView.addSubview(smallPlayOrPauseBtn)
        smallPlayOrPauseBtn.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalToSuperview()
            make.width.height.equalTo(56.0)
        }
        
        currentTimeLabel = UILabel(text: "00:00", textColor: UIColor.white, textFont: UIFont.Semibold(14), textAlignment: .left)
        bottomToolView.addSubview(currentTimeLabel)
        
        currentTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(smallPlayOrPauseBtn.snp.right)
            make.height.equalTo(20)
            make.centerY.equalTo(smallPlayOrPauseBtn.snp.centerY)
            make.width.equalTo(54)
        }
        
        slider = ZFSliderView()
        slider.delegate = self
        slider.maximumTrackTintColor = UIColor.fromHex("#FFFFFF", alpha: 0.5)
        slider.bufferTrackTintColor = UIColor.clear
        slider.minimumTrackTintColor = UIColor.white
        slider.setThumbImage(UIImage(named: "ico_progress_bar"), for: .normal)
        slider.sliderHeight = 2
        slider.thumbSize = CGSize(width: 26, height: 26)
        bottomToolView.addSubview(slider)
        
        totalTimeLabel = UILabel(text: "00:00", textColor: UIColor.white, textFont: UIFont.Semibold(14), textAlignment: .right)
        bottomToolView.addSubview(totalTimeLabel)
        
        totalTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-56.0)
            make.centerY.equalTo(smallPlayOrPauseBtn.snp.centerY)
            make.height.equalTo(20)
            make.width.equalTo(54)
        }
        
        // 68x32
        fullScreenBtn = UIButton(imageName: "ico_full_screen")
        self.fullScreenBtn.addTarget(self, action: #selector(fullScreenButtonClickAction(sender:)), for: .touchUpInside)
        bottomToolView.addSubview(fullScreenBtn)
        
        fullScreenBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(56.0)
            make.top.right.equalToSuperview()
        }
        
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(currentTimeLabel.snp.right)
            make.centerY.equalTo(smallPlayOrPauseBtn.snp.centerY)
            make.height.equalTo(56.0)
            make.right.equalTo(totalTimeLabel.snp.left)
        }
        
        closeBtn = UIButton(imageName: "ico_video_close")
        closeBtn.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        bottomToolView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(40.0)
            make.left.equalTo(10.0)
            make.top.equalTo(smallPlayOrPauseBtn.snp.bottom)
        }
        
        // 添加阴影
        bottomToolViewBgLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor]
        bottomToolViewBgLayer.locations = [0, 1]
        bottomToolViewBgLayer.frame = CGRect(x: 0, y: 0, width: SpeedyApp.screenHeight, height: 56.0 + 52.0 + SpeedyApp.tabBarBottomHeight)
        bottomToolViewBgLayer.startPoint = CGPoint(x: 0.5, y: 0)
        bottomToolViewBgLayer.endPoint = CGPoint(x: 0.5, y: 1)
        bottomToolView.layer.addSublayer(bottomToolViewBgLayer)
    }
    
    /** 重置ControlView */
    func resetControlView() {
        self.topToolView.alpha = 1
        self.bottomToolView.alpha        = 1
        self.slider.value                = 0
        self.slider.bufferValue          = 0
        self.currentTimeLabel.text       = "00:00"
        self.totalTimeLabel.text         = "00:00"
        self.backgroundColor             = UIColor.clear
        self.pauseBtn.isHidden     = true
        self.smallPlayOrPauseBtn.isSelected = true
//        self.titleLabel.text             = ""
    }
    
    /// 显示控制view
    func showControlView(_ animated: Bool) {
        func show() {
            self.player?.isStatusBarHidden      = false;
            self.topToolView.alpha           = 1;
            self.bottomToolView.alpha        = 1;
            self.controlViewAppeared = true
        }
        
        
        // 只有正在播放的时候才自动隐藏
        self.autoHideControlView()
        
        if animated {
            UIView.animate(withDuration: self.autoFadeTimeInterval) {
                show()
            }
        } else {
            show()
        }
    }
    
    /// 隐藏控制层
    func hideControlView(_ animated: Bool) {
        func hide() {
            self.player?.isStatusBarHidden      = false
            self.topToolView.alpha           = 0;
            self.bottomToolView.alpha        = 0;
            self.controlViewAppeared = false
        }
        
        if animated {
            UIView.animate(withDuration: self.autoFadeTimeInterval) {
                hide()
            }
        } else {
            hide()
        }
    }
    
    // 自动隐藏
    func autoHideControlView() {
        
        if self.isPlaying == false || self.isAutoHiding == true {
            return
        }
        
        self.isAutoHiding = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + autoHiddenTimeInterval) {
            if self.canAutoHide {
                self.hideControlView(true)
            }
            self.isAutoHiding = false
        }
    }
    
    func shouldResponseGestureWithPoint(_ point: CGPoint, withGestureType type: ZFPlayerGestureType, touch: UITouch) -> Bool {
        
        let sliderRect = self.bottomToolView.convert(self.slider.frame, to: self)
        if (sliderRect.contains(point)) {
            return false;
        }
        return true;
    }
}

// MARK: - ZFPlayerMediaControl, ZFPlayerControlViewDelegate
extension XHVideoCustomControlView: ZFPlayerMediaControl {
    
    /// 手势筛选，返回NO不响应该手势
    func gestureTriggerCondition(_ gestureControl: ZFPlayerGestureControl, gestureType: ZFPlayerGestureType, gestureRecognizer: UIGestureRecognizer, touch: UITouch) -> Bool {
        
        guard let currentPlayer = self.player else {
            return false
        }
        
        let point = touch.location(in: self)
        if currentPlayer.isSmallFloatViewShow && currentPlayer.isFullScreen == false && gestureType != .singleTap {
            return false
        }
        
        let result = self.shouldResponseGestureWithPoint(point, withGestureType: gestureType, touch: touch)
        return result
    }
    
    /// 单击手势事件
    func gestureSingleTapped(_ gestureControl: ZFPlayerGestureControl) {
        
        guard let currentPlayer = self.player else {
            return
        }
        
        if (currentPlayer.isSmallFloatViewShow && !currentPlayer.isFullScreen) {
            currentPlayer.enterFullScreen(true, animated: true)
        } else {
            self.delegate?.singleTapGesture()
            
            if self.controlViewAppeared {
                self.hideControlView(true)
            } else {
                self.showControlView(true)
            }
        }
    }
    
    /// 双击手势事件
    func gestureDoubleTapped(_ gestureControl: ZFPlayerGestureControl) {
        self.playOrPause()
    }
    
    /// 捏合手势事件，这里改变了视频的填充模式
    func gesturePinched(_ gestureControl: ZFPlayerGestureControl, scale: Float) {
        if (scale > 1) {
            self.player?.currentPlayerManager.scalingMode = .aspectFill
        } else {
            self.player?.currentPlayerManager.scalingMode = .aspectFit
        }
    }
    
    /// 准备播放
    func videoPlayer(_ videoPlayer: ZFPlayerController, prepareToPlay assetURL: URL) {

    }
    
    /// 播放状态改变
    func videoPlayer(_ videoPlayer: ZFPlayerController, playStateChanged state: ZFPlayerPlaybackState) {
        
        if (state == .playStatePlaying) {
            self.hideNetworkErrorTip()
            pauseBtn.isHidden = true
            smallPlayOrPauseBtn.isSelected = true
            /// 开始播放时候判断是否显示loading
            if (videoPlayer.currentPlayerManager.loadState == .stalled) {
                self.activity.startAnimating()
            } else if ((videoPlayer.currentPlayerManager.loadState == .stalled || videoPlayer.currentPlayerManager.loadState == .prepare)) {
                self.activity.startAnimating()
            }
        } else if (state == .playStatePaused) {
            self.hideNetworkErrorTip()
            pauseBtn.isHidden = false
            smallPlayOrPauseBtn.isSelected = false
            self.canAutoHide = false
            self.showControlView(true)
            /// 暂停的时候隐藏loading
            self.activity.stopAnimating()
        } else if (state == .playStatePlayFailed) {
            self.activity.stopAnimating()
            self.showErrorView()
        }
    }
    
    /// 加载状态改变
    func videoPlayer(_ videoPlayer: ZFPlayerController, loadStateChanged state: ZFPlayerLoadState) {
        
        if (state == .prepare) {
            self.coverImageView.isHidden = false
        } else if (state == .playthroughOK || state == .playable) {
            self.coverImageView.isHidden = true;
            self.player?.currentPlayerManager.view.backgroundColor = UIColor.black
        }
        if (state == .stalled && videoPlayer.currentPlayerManager.isPlaying) {
            
            self.activity.startAnimating()
        } else if ((state == .stalled || state == .prepare) && videoPlayer.currentPlayerManager.isPlaying) {
            self.activity.startAnimating()
        } else {
            self.activity.stopAnimating()
        }
    }
    
    /// 播放进度改变回调
    func videoPlayer(_ videoPlayer: ZFPlayerController, currentTime: TimeInterval, totalTime: TimeInterval) {
        if !slider.isdragging{
            let currentTimeString = ZFUtilities.convertTimeSecond(Int(round(currentTime)))
            self.currentTimeLabel.text = currentTimeString
            
            let totalTimeString = ZFUtilities.convertTimeSecond(Int(round(totalTime)))
            self.totalTimeLabel.text = totalTimeString
            slider.value = videoPlayer.progress;
            XHLogDebug("ZFPlayer进度 - progress[\(videoPlayer.progress)]")
        }
    }
    
    /// 缓冲改变回调
    func videoPlayer(_ videoPlayer: ZFPlayerController, bufferTime: TimeInterval) {
        self.slider.bufferValue = videoPlayer.bufferProgress;
    }
    
    func videoPlayer(_ videoPlayer: ZFPlayerController, presentationSizeChanged size: CGSize) {
        
    }
    
    /// 视频view即将旋转
    func videoPlayer(_ videoPlayer: ZFPlayerController, orientationWillChange observer: ZFOrientationObserver) {
        
        if (self.controlViewAppeared) {
            showControlView(false)
        } else {
            hideControlView(false)
        }
    }
    
    /// 视频view已经旋转
    func videoPlayer(_ videoPlayer: ZFPlayerController, orientationDidChanged observer: ZFOrientationObserver) {
        
        if self.controlViewAppeared {
            showControlView(false)
        } else {
            hideControlView(false)
        }
        
        if self.player?.isFullScreen == true {
            
            let leftSpace: CGFloat = SpeedyApp.isIPhoneX ? 44.0 : 20.0
            
            topToolView.snp.updateConstraints { (make) in
                make.height.equalTo(64.0)
            }
            
            closeFullScreenBtn.snp.updateConstraints { (make) in
                make.left.equalTo(leftSpace + 4.0)
            }
            
            self.bottomToolView.snp.updateConstraints { (make) in
                make.height.equalTo(56.0)
            }
            
            smallPlayOrPauseBtn.snp.updateConstraints { (make) in
                make.left.equalTo(leftSpace)
            }
            
            self.totalTimeLabel.snp.updateConstraints { (make) in
                make.right.equalTo(-18)
            }
            
            self.topToolView.isHidden = false
            self.closeBtn.isHidden = true
            self.fullScreenBtn.isHidden = true
            self.closeFullScreenBtn.isHidden = false
        } else {
            
            topToolView.snp.updateConstraints { (make) in
                make.height.equalTo(SpeedyApp.statusBarAndNavigationBarHeight)
            }
            
            closeFullScreenBtn.snp.updateConstraints { (make) in
                make.left.equalTo(4.0)
            }
            
            self.bottomToolView.snp.updateConstraints { (make) in
                make.height.equalTo(56.0 + 52.0 + SpeedyApp.tabBarBottomHeight)
            }
            
            smallPlayOrPauseBtn.snp.updateConstraints { (make) in
                make.left.equalTo(0.0)
            }
            
            self.totalTimeLabel.snp.updateConstraints { (make) in
                make.right.equalTo(-56)
            }
            
            self.topToolView.isHidden = true
            self.closeBtn.isHidden = false
            self.fullScreenBtn.isHidden = false
            self.closeFullScreenBtn.isHidden = true
            
            self.delegate?.closeFullScreen()
        }
        
        layoutIfNeeded()
        setNeedsDisplay()
    }
    
    func lockedVideoPlayer(_ videoPlayer: ZFPlayerController, lockedScreen locked: Bool) {
        showControlView(true)
    }
    
    private func showErrorView() {
        self.hideNetworkErrorTip()
        let errorView = self.showNetworkErrorTip { [weak self] in
            self?.hideNetworkErrorTip()
            self?.retryHandler?()
        }
        errorView.tipLabel?.textColor = UIColor.white
        errorView.tipLabel?.text = "视频加载失败"
    }
}

// MARK: - 处理进度条 ZFSliderViewDelegate
extension XHVideoCustomControlView: ZFSliderViewDelegate {
    
    func sliderTouchBegan(_ value: Float) {
        self.slider.isdragging = true
        self.canAutoHide = false
        XHLogDebug("[视频播放调试] - 开始滑动slider:[\(value)]")
    }
    
    func sliderValueChanged(_ value: Float) {
        guard let currentPlayer = self.player else {
            return
        }
        
        if currentPlayer.totalTime == 0 {
            slider.value = 0.0
            return
        }
        slider.isdragging = true
        let currentTimeString = ZFUtilities.convertTimeSecond(Int(currentPlayer.totalTime*Double(value)))
        self.currentTimeLabel.text = currentTimeString
        XHLogDebug("[视频播放调试] - slider进度变化:[\(value)]")
    }
    
    func sliderTouchEnded(_ value: Float) {
        self.playWhenSliderActionComplete(value)
        XHLogDebug("[视频播放调试] - 滑动slider结束")
    }
    
    func sliderTapped(_ value: Float) {
        self.playWhenSliderActionComplete(value)
        XHLogDebug("[视频播放调试] - 点击slider")
    }
    
    // slider手势结束的时候调用
    private func playWhenSliderActionComplete(_ value: Float) {
        
        guard let currentPlayer = self.player else {
            return
        }
        
        if currentPlayer.totalTime > 0 {
            slider.isdragging = true
            let seekValue = currentPlayer.totalTime*Double(value)
            XHLogDebug("[视频播放调试] - seek:[\(seekValue)] - value:[\(value)]")
            currentPlayer.seek(toTime: seekValue) { [weak self] (finished) in
                if finished {
                    self?.slider.isdragging = false
                    self?.player?.currentPlayerManager.play()
                }
            }
        } else {
            slider.isdragging = false
            slider.value = 0
        }
        
        self.canAutoHide = true
        self.autoHideControlView()
    }
}
