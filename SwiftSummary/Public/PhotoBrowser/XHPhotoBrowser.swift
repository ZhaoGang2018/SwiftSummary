//
//  XHPhotoBrowser.swift
//  XCamera
//
//  Created by jing_mac on 2020/5/26.
//  Copyright © 2020 xhey. All rights reserved.
//  二次封装图片浏览器

import UIKit

typealias XHPhotoBrowserAnimationHandler = (Int) -> (UIView?, UIImage?, CGRect)

class XHPhotoBrowser: JXPhotoBrowser {
    
    // 数据源是一个数组，可以放任何数据，但是需要在设置图片的地方添加兼容方式
    var dataSource: [Any] = []
    var placeholder: UIImage?
    var animationHandler: XHPhotoBrowserAnimationHandler?
    
    // 类方法
    class func show(dataSource: [Any], currentIndex: Int, placeholder: UIImage? = nil, method: ShowMethod = .present(fromVC: nil, embed: nil), animation: XHPhotoBrowserAnimationHandler?) -> XHPhotoBrowser {
        
        let vc = XHPhotoBrowser(dataSource: dataSource, currentIndex: currentIndex, placeholder: placeholder, animation: animation)
        vc.show(method: method)
        
        return vc
    }
    
    // 实例方法
    init(dataSource: [Any], currentIndex: Int, placeholder: UIImage? = nil, animation: XHPhotoBrowserAnimationHandler?) {
        super.init()
        self.dataSource = dataSource
        self.pageIndex = currentIndex
        self.animationHandler = animation
        self.placeholder = placeholder
        
        self.numberOfItems = { [weak self] in
            return self?.dataSource.count ?? 0
        }
        
        self.reloadCellAtIndex = { [weak self] context in
            
            self?.configData(context)
        }
        
        // 更丝滑的Zoom动画
        self.transitionAnimator = JXPhotoBrowserSmoothZoomAnimator(transitionViewAndFrame: { [weak self] (index, destinationView) -> JXPhotoBrowserSmoothZoomAnimator.TransitionViewAndFrame? in
            
            if let handler = self?.animationHandler {
                let result = handler(index)
                if let currentView = result.0 {
                    let transitionView = UIImageView(image: result.1, contentMode: .scaleAspectFill, clipsToBounds: true)
                    let thumbnailFrame = currentView.convert(result.2, to: destinationView)
                    return (transitionView, thumbnailFrame)
                }
            }
            return nil
        })
        
        /*
         self.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { [weak self] index -> UIView? in
         
         if let handler = self?.animationHandler {
         let result = handler(index)
         if let currentView = result.0 {
         return currentView
         }
         }
         return nil
         })
         */
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        XHLogDebug("deinit - XHPhotoBrowser")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - 填充数据
    func configData(_ context: ReloadCellContext) {
        
//        if self.dataSource.count == 0 {
//            return
//        }
//
//        let browserCell = context.cell as? JXPhotoBrowserImageCell
//
//        if let tempModels = self.dataSource as? [String] {
//            // 数据数组里是String
//            browserCell?.imageView.image = UIImage(named: tempModels[context.index])
//
//        } else if let tempModels = self.dataSource as? [UIImage] {
//            // 数据数组里是UIImage
//            browserCell?.imageView.image = tempModels[context.index]
//        } else if let tempModels = self.dataSource as? [XHBrowseTeamPhotoItem] {
//            // 数据数组里是WorkGropPeoplePhotoDetailItem
//            browserCell?.imageView.setImage(with: tempModels[context.index].largeUrl, defaultImage: self.placeholder, complete: { [weak browserCell] (image, url) in
//                browserCell?.setNeedsLayout()
//            })
//        }
    }
    
}





// MARK: - 使用Demo
/*
 1、 本地图片
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         // 实例化
         let browser = JXPhotoBrowser()
         // 浏览过程中实时获取数据总量
         browser.numberOfItems = {
             self.dataSource.count
         }
         // 刷新Cell数据。本闭包将在Cell完成位置布局后调用。
         browser.reloadCellAtIndex = { context in
             let browserCell = context.cell as? JXPhotoBrowserImageCell
             let indexPath = IndexPath(item: context.index, section: indexPath.section)
             browserCell?.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
         }
         // 可指定打开时定位到哪一页
         browser.pageIndex = indexPath.item
         // 展示
         browser.show()
     }

 2、  Zoom转场动画
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.reloadCellAtIndex = { context in
             let browserCell = context.cell as? JXPhotoBrowserImageCell
             let indexPath = IndexPath(item: context.index, section: indexPath.section)
             browserCell?.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
         }
         // 使用Zoom动画
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         browser.pageIndex = indexPath.item
         browser.show()
     }


 3、 更丝滑的Zoom转场动画

 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.reloadCellAtIndex = { context in
             let browserCell = context.cell as? JXPhotoBrowserImageCell
             let indexPath = IndexPath(item: context.index, section: indexPath.section)
             browserCell?.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
         }
         // 更丝滑的Zoom动画
         browser.transitionAnimator = JXPhotoBrowserSmoothZoomAnimator(transitionViewAndFrame: { (index, destinationView) -> JXPhotoBrowserSmoothZoomAnimator.TransitionViewAndFrame? in
             let path = IndexPath(item: index, section: indexPath.section)
             guard let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell else {
                 return nil
             }
             let image = cell.imageView.image
             let transitionView = UIImageView(image: image)
             transitionView.contentMode = cell.imageView.contentMode
             transitionView.clipsToBounds = true
             let thumbnailFrame = cell.imageView.convert(cell.imageView.bounds, to: destinationView)
             return (transitionView, thumbnailFrame)
         })
         browser.pageIndex = indexPath.item
         browser.show(method: .push(inNC: nil))
     }


 4、 网络图片-Kingfisher

 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.reloadCellAtIndex = { context in
             let url = self.dataSource[context.index].secondLevelUrl.flatMap { URL(string: $0) }
             let browserCell = context.cell as? JXPhotoBrowserImageCell
             let collectionPath = IndexPath(item: context.index, section: indexPath.section)
             let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
             let placeholder = collectionCell?.imageView.image
             // 用Kingfisher加载
             browserCell?.imageView.kf.setImage(with: url, placeholder: placeholder, options: [], completionHandler: { _ in
                 browserCell?.setNeedsLayout()
             })
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         browser.pageIndex = indexPath.item
         browser.show()
     }


 5、 网络图片-SDWebImage
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.reloadCellAtIndex = { context in
             let url = self.dataSource[context.index].secondLevelUrl.flatMap { URL(string: $0) }
             let browserCell = context.cell as? JXPhotoBrowserImageCell
             browserCell?.index = context.index
             let collectionPath = IndexPath(item: context.index, section: indexPath.section)
             let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
             let placeholder = collectionCell?.imageView.image
             // 用SDWebImage加载
             browserCell?.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: { (_, _, _, _) in
                 browserCell?.setNeedsLayout()
             })
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         browser.pageIndex = indexPath.item
         browser.show()
     }


 6、 网络图片显示加载进度
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         // 使用自定义的Cell
         browser.cellClassAtIndex = { _ in
             LoadingImageCell.self
         }
         browser.reloadCellAtIndex = { context in
             let browserCell = context.cell as? LoadingImageCell
             let collectionPath = IndexPath(item: context.index, section: indexPath.section)
             let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
             let placeholder = collectionCell?.imageView.image
             browserCell?.reloadData(placeholder: placeholder, urlString: self.dataSource[context.index].secondLevelUrl)
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         browser.pageIndex = indexPath.item
         browser.show()
     }


 7、 显示查看原图
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         // 使用自定义的Cell
         browser.cellClassAtIndex = { _ in
             RawImageCell.self
         }
         browser.reloadCellAtIndex = { context in
             let browserCell = context.cell as? RawImageCell
             let collectionPath = IndexPath(item: context.index, section: indexPath.section)
             let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
             let placeholder = collectionCell?.imageView.image
             let urlString = self.dataSource[context.index].secondLevelUrl
             let rawURLString = self.dataSource[context.index].thirdLevelUrl
             browserCell?.reloadData(placeholder: placeholder, urlString: urlString, rawURLString: rawURLString)
         }
         browser.pageIndex = indexPath.item
         browser.show()
     }

 8、 加载GIF图片
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.reloadCellAtIndex = { context in
             let url = self.dataSource[context.index].secondLevelUrl.flatMap { URL(string: $0) }
             let browserCell = context.cell as? JXPhotoBrowserImageCell
             let collectionPath = IndexPath(item: context.index, section: indexPath.section)
             let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
             let placeholder = collectionCell?.imageView.image
             // 用SDWebImage加载
             browserCell?.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: { (_, _, _, _) in
                 browserCell?.setNeedsLayout()
             })
             // Kingfisher
             /*browserCell?.imageView.kf.setImage(with: url, placeholder: placeholder, options: [], completionHandler: { _ in
                 browserCell?.setNeedsLayout()
             })*/
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         browser.pageIndex = indexPath.item
         browser.show()
     }

 9、 删除图片-长按事
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.reloadCellAtIndex = { context in
             guard let browserCell = context.cell as? JXPhotoBrowserImageCell else {
                 return
             }
             let indexPath = IndexPath(item: context.index, section: indexPath.section)
             // 必须从数据源取数据，不能取collectionCell的imageView里的图片，
             // 在更改数据源后即使reloadData，也可能取不到，因为UIImageView的图片需要一个更新周期。
             browserCell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
             browserCell.index = context.index
             // 添加长按事件
             browserCell.longPressedAction = { cell, _ in
                 self.longPress(cell: cell)
             }
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         browser.pageIndex = indexPath.item
         browser.show()
     }
     
     private func longPress(cell: JXPhotoBrowserImageCell) {
         let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
         alert.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { _ in
             self.dataSource.remove(at: cell.index)
             self.collectionView.reloadData()
             cell.photoBrowser?.reloadData()
         }))
         alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
         cell.photoBrowser?.present(alert, animated: true, completion: nil)
     }

 10、 无限新增图片
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.reloadCellAtIndex = { context in
             let browserCell = context.cell as? JXPhotoBrowserImageCell
             let indexPath = IndexPath(item: context.index, section: indexPath.section)
             browserCell?.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         // 监听页码变化
         browser.didChangedPageIndex = { index in
             // 已到最后一张
             if index == self.dataSource.count - 1 {
                 self.appendMoreData(browser: browser)
             }
         }
         browser.scrollDirection = .vertical
         browser.pageIndex = indexPath.item
         browser.show()
     }
     
     private func appendMoreData(browser: JXPhotoBrowser) {
         var randomIndexes = (0..<6).map { $0 }
         randomIndexes.shuffle()
         randomIndexes.forEach { index in
             let model = ResourceModel()
             model.localName = "local_\(index)"
             dataSource.append(model)
         }
         collectionView.reloadData()
         // TODO: UIScrollView的pageEnable特性原因，不能很好衔接，效果上有点问题，还未解决
         browser.reloadData()
     }

 11、 带导航栏Push
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.reloadCellAtIndex = { context in
             guard let browserCell = context.cell as? JXPhotoBrowserImageCell else {
                 return
             }
             let indexPath = IndexPath(item: context.index, section: indexPath.section)
             browserCell.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
             // 添加长按事件
             browserCell.longPressedAction = { cell, _ in
                 self.longPress(cell: cell)
             }
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         browser.pageIndex = indexPath.item
         // 让PhotoBrowser嵌入当前的导航控制器里
         browser.show(method: .push(inNC: nil))
         
         /*
         // 让PhotoBrowser嵌入新创建的导航控制器里，present。
         // 注：此用法下暂不支持屏幕旋转，若app支持旋转的话，此种使用方式暂未适配
         browser.show(method: .present(fromVC: self, embed: { browser -> UINavigationController in
             return UINavigationController.init(rootViewController: browser)
         }))
         */
     }
     
     private func longPress(cell: JXPhotoBrowserImageCell) {
         let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
         alert.addAction(UIAlertAction(title: "查看详情", style: .destructive, handler: { _ in
             let detail = MoreDetailViewController()
             cell.photoBrowser?.navigationController?.pushViewController(detail, animated: true)
         }))
         alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
         cell.photoBrowser?.present(alert, animated: true, completion: nil)
     }

 13、 多种类视图
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count + 1
         }
         browser.cellClassAtIndex = { index in
             if index < self.dataSource.count {
                 return JXPhotoBrowserImageCell.self
             }
             return MoreCell.self
         }
         browser.reloadCellAtIndex = { context in
             if context.index < self.dataSource.count {
                 let browserCell = context.cell as? JXPhotoBrowserImageCell
                 let indexPath = IndexPath(item: context.index, section: indexPath.section)
                 browserCell?.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
             }
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             if index < self.dataSource.count {
                 let path = IndexPath(item: index, section: indexPath.section)
                 let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
                 return cell?.imageView
             }
             return nil
         })
         browser.pageIndex = indexPath.item
         browser.show()
     }

 class MoreCell: UIView, JXPhotoBrowserCell {
     
     weak var photoBrowser: JXPhotoBrowser?
     
     static func generate(with browser: JXPhotoBrowser) -> Self {
         let instance = Self.init(frame: .zero)
         instance.photoBrowser = browser
         return instance
     }
     
     var onClick: (() -> Void)?
     
     lazy var button: UIButton = {
         let btn = UIButton(type: .custom)
         btn.setTitle("  更多 +  ", for: .normal)
         btn.setTitleColor(UIColor.darkText, for: .normal)
         return btn
     }()
     
     required override init(frame: CGRect) {
         super.init(frame: .zero)
         backgroundColor = .white
         addSubview(button)
         button.addTarget(self, action: #selector(click), for: .touchUpInside)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         button.sizeToFit()
         button.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
     }
     
     @objc private func click() {
         photoBrowser?.dismiss()
     }
 }

 14、 多Section场景
 override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         collectionView.deselectItem(at: indexPath, animated: false)
         let browser = JXPhotoBrowser()
         // 图片总数
         browser.numberOfItems = {
             return self.sections.reduce(0) { (result, modelArray) -> Int in
                 result + modelArray.count
             }
         }
         // 刷新Cell数据。本闭包将在Cell完成位置布局后调用。
         browser.reloadCellAtIndex = { context in
             let (indexPath, model) = self.indexPathFor(browserIndex: context.index)
             let collectionCell = collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell
             let placeholder = collectionCell?.imageView.image
             let browserCell = context.cell as? JXPhotoBrowserImageCell
             if let urlString = model.secondLevelUrl {
                 let url = URL(string: urlString)
                 browserCell?.imageView.kf.setImage(with: url, placeholder: placeholder, options: [], completionHandler: { _ in
                     browserCell?.setNeedsLayout()
                 })
             } else if let localName = model.localName {
                 browserCell?.imageView.image = UIImage(named: localName)
             }
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let (path, _) = self.indexPathFor(browserIndex: index)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         // 指定打开时定位到哪一页
         browser.pageIndex = browserIndexFor(indexPath: indexPath)
         // 展示
         browser.show()
     }
     
     /// 计算所浏览图片处于哪个section哪个item
     private func indexPathFor(browserIndex: Int) -> (IndexPath, ResourceModel) {
         var section = 0, count = 0
         for modelArray in sections {
             var item = 0
             for model in modelArray {
                 if count == browserIndex {
                     return (IndexPath(item: item, section: section), model)
                 }
                 count += 1
                 item += 1
             }
             section += 1
         }
         fatalError("所浏览的图片(index:\(browserIndex))找不到其在前向页面的位置！")
     }
     
     /// 计算IndexPath对应第几张图片
     private func browserIndexFor(indexPath: IndexPath) -> Int {
         var section = 0, count = 0
         for modelArray in sections {
             var item = 0
             for _ in modelArray {
                 if section == indexPath.section && item == indexPath.item {
                     return count
                 }
                 count += 1
                 item += 1
             }
             section += 1
         }
         fatalError("无法计算\(indexPath)对应的图片序号！")
     }


 15、 视频与图片混合浏览
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.cellClassAtIndex = { index in
             index % 2 == 0 ? VideoCell.self : JXPhotoBrowserImageCell.self
         }
         browser.reloadCellAtIndex = { context in
             JXPhotoBrowserLog.high("reload cell!")
             let resourceName = self.dataSource[context.index].localName!
             if context.index % 2 == 0 {
                 let browserCell = context.cell as? VideoCell
                 if let url = Bundle.main.url(forResource: resourceName, withExtension: "MP4") {
                     browserCell?.player.replaceCurrentItem(with: AVPlayerItem(url: url))
                 }
             } else {
                 let browserCell = context.cell as? JXPhotoBrowserImageCell
                 browserCell?.imageView.image = UIImage(named: resourceName)
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
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         browser.pageIndex = indexPath.item
         browser.show()
     }

 16、 竖向浏览视频
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         // 指定滑动方向为垂直
         browser.scrollDirection = .vertical
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.cellClassAtIndex = { index in
             VideoCell.self
         }
         browser.reloadCellAtIndex = { context in
             JXPhotoBrowserLog.high("reload cell!")
             let resourceName = self.dataSource[context.index].localName!
             let browserCell = context.cell as? VideoCell
             if let url = Bundle.main.url(forResource: resourceName, withExtension: "MP4") {
                 browserCell?.player.replaceCurrentItem(with: AVPlayerItem(url: url))
             }
         }
         browser.cellWillAppear = { cell, index in
             JXPhotoBrowserLog.high("开始播放")
             (cell as? VideoCell)?.player.play()
         }
         browser.cellWillDisappear = { cell, index in
             JXPhotoBrowserLog.high("暂停播放")
             (cell as? VideoCell)?.player.pause()
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         browser.pageIndex = indexPath.item
         browser.show()
     }

 17、 UIPageControl样式的页码指示器
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.reloadCellAtIndex = { context in
             let url = self.dataSource[context.index].secondLevelUrl.flatMap { URL(string: $0) }
             let browserCell = context.cell as? JXPhotoBrowserImageCell
             browserCell?.index = context.index
             let collectionPath = IndexPath(item: context.index, section: indexPath.section)
             let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
             let placeholder = collectionCell?.imageView.image
             browserCell?.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: { (_, _, _, _) in
                 browserCell?.setNeedsLayout()
             })
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         // UIPageIndicator样式的页码指示器
         browser.pageIndicator = JXPhotoBrowserDefaultPageIndicator()
         browser.pageIndex = indexPath.item
         browser.show()
     }


 18、 数字样式的页码指示器
 override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
         let browser = JXPhotoBrowser()
         browser.numberOfItems = {
             self.dataSource.count
         }
         browser.reloadCellAtIndex = { context in
             let url = self.dataSource[context.index].secondLevelUrl.flatMap { URL(string: $0) }
             let browserCell = context.cell as? JXPhotoBrowserImageCell
             browserCell?.index = context.index
             let collectionPath = IndexPath(item: context.index, section: indexPath.section)
             let collectionCell = collectionView.cellForItem(at: collectionPath) as? BaseCollectionViewCell
             let placeholder = collectionCell?.imageView.image
             browserCell?.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: { (_, _, _, _) in
                 browserCell?.setNeedsLayout()
             })
         }
         browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
             let path = IndexPath(item: index, section: indexPath.section)
             let cell = collectionView.cellForItem(at: path) as? BaseCollectionViewCell
             return cell?.imageView
         })
         // 数字样式的页码指示器
         browser.pageIndicator = JXPhotoBrowserNumberPageIndicator()
         browser.pageIndex = indexPath.item
         browser.show()
     }
 */
