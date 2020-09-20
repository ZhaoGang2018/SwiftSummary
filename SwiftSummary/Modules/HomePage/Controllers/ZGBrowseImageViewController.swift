//
//  ZGBrowseImageViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/9/7.
//  Copyright © 2020 zhaogang. All rights reserved.
//

import UIKit
import ZFPlayer

class ZGBrowseImageViewController: XHBaseViewController {
    
    let imageNames: [String] = ["local_0", "local_1", "local_2", "local_3", "local_4", "local_5"]
    var imageViews: [UIImageView] = []
    
    var player: ZFPlayerController?
    var controlView: ZFWeChatControlView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space_x: CGFloat = (SpeedyApp.screenWidth - 100.0*3.0)/4.0
        
        for index in 0..<imageNames.count {
            let imageView = UIImageView(imageName: imageNames[index])
            imageView.tag = index
            _ = imageView.addTapGestureRecognizer(target: self, action: #selector(imageViewTapAction(sender:)))
            view.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.width.height.equalTo(100)
                make.left.equalTo(space_x + (100.0 + space_x)*CGFloat(index%3))
                make.top.equalTo(150.0 + (120.0)*CGFloat(index/3))
            }
        }
    }
    
    func configPlayer() {
        
        let playerManager = ZFAVPlayerManager()
        playerManager.scalingMode = .aspectFill
        
        self.player = ZFPlayerController(playerManager: playerManager, containerView: self.view)
        self.player?.controlView = ZFWeChatControlView()
        
        /// 0.4是消失40%时候
        self.player?.playerDisapperaPercent = 0.4
        /// 0.6是出现60%时候
        self.player?.playerApperaPercent = 0.6
        /// 移动网络依然自动播放
        self.player?.isWWANAutoPlay = true
        /// 续播
        self.player?.resumePlayRecord = true
        /// 禁止掉滑动手势
        self.player?.disableGestureTypes = .pan
        /// 竖屏的全屏
        self.player?.orientationObserver.fullScreenMode = .portrait
        /// 隐藏全屏的状态栏
        self.player?.orientationObserver.fullScreenStatusBarHidden = true
        self.player?.orientationObserver.fullScreenStatusBarAnimation = .none
        
        /// 全屏的填充模式（全屏填充、按视频大小填充）
        self.player?.orientationObserver.portraitFullScreenMode = .scaleAspectFit
        
        /// 禁用竖屏全屏的手势（点击、拖动手势）
        self.player?.orientationObserver.disablePortraitGestureTypes = .init(rawValue: 0)
        
        self.player?.playerDidToEnd = {[weak self] (asset) in
            self?.player?.currentPlayerManager.replay()
        }
        
        /*
         self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
             kAPPDelegate.allowOrentitaionRotation = isFullScreen;
         };
         */
        self.player?.orientationWillChange = {[weak self] (player, isFullScreen) in
            
        }
        
        /// 停止的时候找出最合适的播放
        //        self.player?.zf_scrollViewDidEndScrollingCallback = {[weak self] (indexPath) in
        //            if self?.player?.playingIndexPath == false {
        //  [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
        //            }
        //        }
        
        /*
         /// 滑动中找到适合的就自动播放
         /// 如果是停止后再寻找播放可以忽略这个回调
         /// 如果在滑动中就要寻找到播放的indexPath，并且开始播放，那就要这样写
         self.player.zf_playerShouldPlayInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
         @zf_strongify(self)
         if ([indexPath compare:self.player.playingIndexPath] != NSOrderedSame) {
         [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
         }
         };
         */
    }
    
    @objc private func imageViewTapAction(sender: UIGestureRecognizer) {
        guard let currentView = sender.view else {
            return
        }
        let currentIndex = currentView.tag
        
        let image = UIImage(named: self.imageNames[currentIndex])
        let videoURL = "https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4"
        
        let model = XHPreviewImageOrVideoModel(type: .video, image: image , imageUrlStr: nil, videoPath: videoURL, videoUrlStr: "", placeholderUrlStr: "", placeholderImage: image)
        
        let browserVC = XHPreviewImageOrVideoViewController(dataSource: [model], currentIndex: 0) { (index) -> (UIView?, UIImage?, CGRect) in
            
            return (currentView, image, currentView.bounds)
        }
        
        browserVC.show(method: .present(fromVC: self, embed: nil))
    }
    
    /*
    @objc private func imageViewTapAction(sender: UIGestureRecognizer) {
        guard let currentView = sender.view else {
            return
        }
        
        let currentIndex = currentView.tag
        
        let browser = JXPhotoBrowser()
        browser.numberOfItems = {
            self.imageNames.count
        }
        browser.cellClassAtIndex = { index in
            index % 2 == 0 ? VideoCell.self : JXPhotoBrowserImageCell.self
        }
        browser.reloadCellAtIndex = { context in
            JXPhotoBrowserLog.high("reload cell!")
            let resourceName = "video_1" //self.imageNames[context.index]
            if context.index % 2 == 0 {
                let browserCell = context.cell as? VideoCell
                browserCell?.imageView.image = UIImage(named: self.imageNames[currentIndex])
                if let url = Bundle.main.url(forResource: resourceName, withExtension: "MP4") {
                    browserCell?.player.replaceCurrentItem(with: AVPlayerItem(url: url))
                }
            } else {
                let browserCell = context.cell as? JXPhotoBrowserImageCell
                browserCell?.imageView.image = UIImage(named: self.imageNames[currentIndex])
            }
        }
        browser.cellWillAppear = { cell, index in
            if index % 2 == 0 {
                JXPhotoBrowserLog.high("开始播放")
                (cell as? VideoCell)?.player.play()
            }
        }
        browser.cellWillDisappear = { cell, index in
            if index % 2 == 0 {
                JXPhotoBrowserLog.high("暂停播放")
                (cell as? VideoCell)?.player.pause()
            }
        }
        browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
//            let path = IndexPath(item: index, section: indexPath.section)
//            let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
//            return cell?.imageView
            
            
            return nil
        })
        browser.pageIndex = currentIndex
        browser.show()
    }
 */
    
}



import Foundation
import UIKit
import AVFoundation

class VideoCell: JXPhotoBrowserImageCell {
    
//    weak var photoBrowser: JXPhotoBrowser?
    
    lazy var player = AVPlayer()
    lazy var playerLayer = AVPlayerLayer(player: player)
    
//    static func generate(with browser: JXPhotoBrowser) -> Self {
//        let instance = Self.init(frame: .zero)
//        instance.photoBrowser = browser
//        return instance
//    }
    
    required init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(click))
        addGestureRecognizer(tap)
        
//        layer.addSublayer(playerLayer)
        self.imageView.layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        playerLayer.frame = bounds
        
        playerLayer.frame = self.imageView.frame
    }
    
    @objc private func click() {
        photoBrowser?.dismiss()
    }
}

// MARK: - ZFWeChatControlView
class ZFWeChatControlView: UIView, ZFPlayerMediaControl {
    var player: ZFPlayerController?
    var activity: ZFLoadingView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.activity = ZFLoadingView()
        self.activity?.hidesWhenStopped = true
        self.activity?.animType = .fadeOut
        self.addSubview(self.activity!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showCoverViewWithUrl(_ coverUrl: String) {
        
        self.player?.currentPlayerManager.view.coverImageView.setImageWithURLString(coverUrl, placeholder: UIImage(named: "img_video_loading"))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let min_x: CGFloat = 0
        let min_y: CGFloat = 0
        let min_w: CGFloat = 44
        let min_h: CGFloat = 44
        
        self.activity?.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        self.activity?.zf_centerX = self.zf_centerX;
        self.activity?.zf_centerY = self.zf_centerY;
    }
    
     /// 播放状态改变
    func videoPlayer(_ videoPlayer: ZFPlayerController, playStateChanged state: ZFPlayerPlaybackState) {
        
        if (state == .playStatePlaying) {
            /// 开始播放时候判断是否显示loading
            if (videoPlayer.currentPlayerManager.loadState == .stalled) {
                self.activity?.startAnimating()
            } else if ((videoPlayer.currentPlayerManager.loadState == .stalled || videoPlayer.currentPlayerManager.loadState == .prepare)) {
                self.activity?.startAnimating()
            }
        } else if (state == .playStatePaused) {
            /// 暂停的时候隐藏loading
            self.activity?.stopAnimating()
        } else if (state == .playStatePlayFailed) {
            self.activity?.stopAnimating()
        }
    }
    
    /// 加载状态改变
    func videoPlayer(_ videoPlayer: ZFPlayerController, loadStateChanged state: ZFPlayerLoadState) {
        if (state == .stalled && videoPlayer.currentPlayerManager.isPlaying) {
            self.activity?.startAnimating()
        } else if ((state == .stalled || state == .prepare) && videoPlayer.currentPlayerManager.isPlaying) {
            self.activity?.startAnimating()
        } else {
            self.activity?.stopAnimating()
        }
    }
    
    func gestureSingleTapped(_ gestureControl: ZFPlayerGestureControl) {
        if (self.player?.isFullScreen == false) {
            self.player?.enterPortraitFullScreen(true, animated: true)
        }
    }
    
    /// 手势筛选，返回NO不响应该手势
    func gestureTriggerCondition(_ gestureControl: ZFPlayerGestureControl, gestureType: ZFPlayerGestureType, gestureRecognizer: UIGestureRecognizer, touch: UITouch) -> Bool {
        
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
            if (gestureRecognizer == gestureControl.singleTap && self.player?.isFullScreen == false) {
                return true;
            }
            return false;
        }
        return true;
    }
    
}

