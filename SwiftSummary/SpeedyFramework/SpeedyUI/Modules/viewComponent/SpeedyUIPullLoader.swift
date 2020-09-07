//
//  SpeedyUIPullLoader.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/11.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit
import MJRefresh

enum PullLoaderDirection : Int {
    case top
    case bottom
}

enum PullLoaderStyle: Int {
    case header
    case footer
    case headerAndFooter
}

typealias SpeedyUIPullLoaderOnRefreshBlock = (PullLoaderDirection) -> ()

class SpeedyUIPullLoader: NSObject {
    
    var onRefresh : SpeedyUIPullLoaderOnRefreshBlock?
    weak var scrollView: UIScrollView?
    
    var style: PullLoaderStyle?
    
    var indicatorViewStyle: UIActivityIndicatorView.Style {
        set {
            if let header : SpeedyUIPullLoaderHeader  = self.scrollView?.mj_header as? SpeedyUIPullLoaderHeader {
//                header.activityIndicatorViewStyle = newValue
                header.loadingView?.style = newValue
            }
            
            if let footer : SpeedyUIPullLoaderFooter  = self.scrollView?.mj_footer as? SpeedyUIPullLoaderFooter {
//                footer.activityIndicatorViewStyle = newValue
                footer.loadingView?.style = newValue
            }
        }
        
        get {
            return .gray
        }
    }
    var hiddenText:Bool {
        set {
            
            if let footer : SpeedyUIPullLoaderFooter  = self.scrollView?.mj_footer as? SpeedyUIPullLoaderFooter {
                footer.stateLabel?.isHidden = newValue
                footer.isRefreshingTitleHidden = newValue
            }
        }
        get {
            return true
        }
    }
    
    var isLoading: Bool {
        
        if let header = self.scrollView?.mj_header, header.state == .refreshing {
            return true
        }
        
        if let footer = self.scrollView?.mj_footer, footer.state == .refreshing {
            return true
        }
        return false
    }
    
    init(scrollView: UIScrollView, pullStyle:PullLoaderStyle) {
        super.init()
        self.indicatorViewStyle = .gray
        self.scrollView = scrollView
        buildSelf(pullStyle: pullStyle)
    }
    init(scrollView: UIScrollView, pullStyle:PullLoaderStyle, hiddenText:Bool) {
        super.init()
        
        self.indicatorViewStyle = .gray
        self.scrollView = scrollView
        buildSelf(pullStyle: pullStyle)
        self.hiddenText = hiddenText
    }
    
    private func buildSelf(pullStyle: PullLoaderStyle) {
        
        self.style = pullStyle
        
        let onHeaderRefresh : MJRefreshComponentAction = { [weak self] in
            self?.handRefresh(diretion: .top)
        }
        
        let onFooterRefresh: MJRefreshComponentAction = { [weak self] in
            self?.handRefresh(diretion: .bottom)
        }
        
        if let currentStyle = self.style {
            
            switch currentStyle {
            case .header:
                self.scrollView?.mj_header = SpeedyUIPullLoaderHeader.init(refreshingBlock: onHeaderRefresh)
                
            case .footer:
                self.scrollView?.mj_footer = SpeedyUIPullLoaderFooter.init(refreshingBlock: onFooterRefresh)
                
            case .headerAndFooter:
                self.scrollView?.mj_header = SpeedyUIPullLoaderHeader.init(refreshingBlock: onHeaderRefresh)
                self.scrollView?.mj_footer = SpeedyUIPullLoaderFooter.init(refreshingBlock: onFooterRefresh)
            }
        }
    }
    
    private func handRefresh(diretion: PullLoaderDirection) {
        // 下拉刷新的时候如果有下拉加载更多，则重置没有更多的数据
        if let footer = self.scrollView?.mj_footer, diretion == .top {
            footer.resetNoMoreData()
        }
        
        if let handler = self.onRefresh {
            handler(diretion)
        }
    }
    
    func startRefresh() {
        if let header = self.scrollView?.mj_header {
            header.beginRefreshing()
        }
    }
    
    func endRefresh() {
        
        if let header = self.scrollView?.mj_header, header.state == .refreshing {
            header.endRefreshing()
        }
        
        if let footer = self.scrollView?.mj_footer, footer.state == .refreshing {
            footer.endRefreshing()
        }
    }
    
    func endRefreshWithNoMoreData() {
        
        if let header = self.scrollView?.mj_header, header.state == .refreshing {
            header.endRefreshing()
        }
        
        // 此处不要判断是否正在refreshing
        if let footer = self.scrollView?.mj_footer {
            footer.endRefreshingWithNoMoreData()
        }
    }
}
