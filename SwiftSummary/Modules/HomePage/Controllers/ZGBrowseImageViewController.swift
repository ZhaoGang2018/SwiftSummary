//
//  ZGBrowseImageViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/9/7.
//  Copyright © 2020 zhaogang. All rights reserved.
//

import UIKit

class ZGBrowseImageViewController: XHBaseViewController {
    
    let imageNames: [String] = ["local_0", "local_1", "local_2", "local_3", "local_4", "local_5"]
    var imageViews: [UIImageView] = []
    
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
