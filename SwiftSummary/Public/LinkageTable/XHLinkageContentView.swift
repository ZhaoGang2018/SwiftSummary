//
//  XHLinkageContentView.swift
//  XCamera
//
//  Created by 赵刚 on 2020/6/9.
//  Copyright © 2020 xhey. All rights reserved.
// 这个里面包括segment和内部的表格

import UIKit

typealias XHLinkageContentViewSelectHandler = (_ index: Int) -> ()

protocol XHLinkageContentViewDelegate: NSObject {
    
    // XHLinkageContentView开始滑动
    func contentViewWillBeginDragging(contentView: XHLinkageContentView)
    
    /**
    NALinkageContentView滑动调用
    @param contentView NALinkageContentView
    @param startIndex 开始滑动页面索引
    @param endIndex 结束滑动页面索引
    @param progress 滑动进度
    */
    func contentViewDidScroll(contentView: XHLinkageContentView, startIndex: Int, endIndex: Int, progress: CGFloat)
    
    /**
    NALinkageContentView结束滑动
    
    @param contentView NALinkageContentView
    @param startIndex 开始滑动索引
    @param endIndex 结束滑动索引
    */
    func contenViewDidEndDecelerating(contentView: XHLinkageContentView, startIndex: Int, endIndex: Int)
}

class XHLinkageContentView: UIView {
    
    var segmentView: XHSegmentBar?
    var collectionView: UICollectionView?
    
    // 能不能横向滑动
    var scrollEnabled: Bool = true {
        didSet {
            self.collectionView?.isScrollEnabled = scrollEnabled
        }
    }
    
    weak var delegate: XHLinkageContentViewDelegate?
    
    var titles: [String] = [] {
        didSet {
            self.segmentView?.titles = self.titles
        }
    }
    var pages: [UIView] = [] {
        didSet {
            var index = 0
            for _ in self.pages {
                self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "XHLinkageCollectionCell_\(index)")
                index += 1
            }
            self.collectionView?.reloadData()
        }
    }
    
    var selectHandler: XHLinkageContentViewSelectHandler?
    
    // 滑动开始的偏移量
    var startOffsetX: CGFloat = 0.0
    
    // 是否是滑动，还是点击的segment
    var isSelectButton: Bool = false
    
    init(titles: [String], pages: [UIView], onSelect: XHLinkageContentViewSelectHandler?) {
        super.init(frame: CGRect.zero)
        self.titles = titles
        self.pages = pages
        self.selectHandler = onSelect
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        
        self.startOffsetX = 0;
        self.isSelectButton = false;
        
        buildSegmentView()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 42.0, width: SpeedyApp.screenWidth, height: SpeedyApp.screenHeight - 42.0), collectionViewLayout: flowLayout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.fromHex("#EFEFF4")
        self.addSubview(collectionView!)
        
        collectionView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentView!.snp.bottom)
        })
        
        var index = 0
        for _ in self.pages {
            self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "XHLinkageCollectionCell_\(index)")
            index += 1
        }
        self.collectionView?.reloadData()
    }
    
    private func buildSegmentView() {
        
        segmentView = XHSegmentBar()
        segmentView?.titles = self.titles
        self.addSubview(segmentView!)
        
        segmentView?.snp.makeConstraints({ (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(42)
        })
        
        segmentView?.onSelect = {[weak self] index in
            
            if let weakSelf = self {
                weakSelf.isSelectButton = true
                
                var offset = weakSelf.collectionView?.contentOffset ?? CGPoint.zero
                offset.x = CGFloat(index) * SpeedyApp.screenWidth
                
                weakSelf.collectionView?.setContentOffset(offset, animated: true)
                if let handler = weakSelf.selectHandler {
                    handler(index)
                }
            }
        }
    }
    
}

extension XHLinkageContentView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.pages.count == 0 {
            return UICollectionViewCell()
        }
        
        let reuseID = "XHLinkageCollectionCell_\(indexPath.row)"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! XHLinkageCollectionCell
        cell.configView(self.pages[indexPath.row])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.isSelectButton) {
            return;
        }
        
        let scrollView_W = scrollView.bounds.size.width;
        let currentOffsetX = scrollView.contentOffset.x;
        let startIndex: Int = Int(floor(startOffsetX / scrollView_W));
        var endIndex: Int
        var progress: CGFloat = 0.0
        if (currentOffsetX > startOffsetX) {
            //左滑left
            progress = (currentOffsetX - startOffsetX)/scrollView_W;
            endIndex = startIndex + 1;
            if (endIndex > self.pages.count - 1) {
                endIndex = self.pages.count - 1;
            }
        }
        else if (currentOffsetX == startOffsetX){
            //没滑过去
            progress = 0;
            endIndex = startIndex;
        }
        else{
            //右滑right
            progress = (startOffsetX - currentOffsetX)/scrollView_W;
            endIndex = startIndex - 1;
            endIndex = endIndex < 0 ? 0 : endIndex;
        }
        
        self.delegate?.contentViewDidScroll(contentView: self, startIndex: startIndex, endIndex: endIndex, progress: progress)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.isSelectButton = false
        self.startOffsetX = scrollView.contentOffset.x
        self.delegate?.contentViewWillBeginDragging(contentView: self)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let scrollView_W = scrollView.bounds.size.width
        let currentOffsetX = scrollView.contentOffset.x
        let startIndex: Int = Int(floor(startOffsetX/scrollView_W))
        let endIndex: Int = Int(floor(currentOffsetX/scrollView_W))
        
        if startIndex < 0 || startIndex >= self.pages.count {
            return
        }
        
        if endIndex < 0 || endIndex >= self.pages.count {
            return
        }
        
        self.delegate?.contenViewDidEndDecelerating(contentView: self, startIndex: startIndex, endIndex: endIndex)
        self.segmentView?.selectedIndex = endIndex;
    }
}



class XHLinkageCollectionCell: UICollectionViewCell {
    
    var pageView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(_ pageView: UIView) {
        
        if let tempView = self.pageView {
            tempView.removeFromSuperview()
        }
        
        self.pageView = pageView
        contentView.addSubview(pageView)
        
        pageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        self.layoutIfNeeded()
    }
    
}
