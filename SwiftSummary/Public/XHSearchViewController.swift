//
//  XHSearchViewController.swift
//  XCamera
//
//  Created by jing_mac on 2020/2/26.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

enum XHSearchType: Int {
    case clickDoneSearch = 0 // 点击完成搜索
    case enterTextSearch = 1 // 每输入一个字都要搜索
}

typealias XHSearchKeywordHandler = (_ keyword: String, _ resultView: UIView?, _ preSearchView: UIView?) -> ()

typealias XHSearchClearResultHandler = (_ resultView: UIView?, _ preSearchView: UIView?) -> ()
typealias XHSearchCancleResultHandler = () -> ()

class XHSearchViewController: XHBaseViewController {
    
    var searchType: XHSearchType = .clickDoneSearch
    // 搜索前的界面
    var preSearchView: UIView?
    // 搜索结果的界面
    var resultView: UIView?
    // 根据关键字开始搜索
    var keywordHandler: XHSearchKeywordHandler?
    // 清空上一次的搜索结果
    var clearResultHandler: XHSearchClearResultHandler?
    // 取消操作
    var cancleHandler: XHSearchCancleResultHandler?
    
    var textField: UITextField?
    var placeholder: String = "搜索成员"
    
    // 隐藏键盘的按钮
//    var bigBtn: UIButton?
    
    deinit {
        XHLogDebug("[deinit] - XHSearchViewController")
        NotificationCenter.default.removeObserver(self)
    }
    
    init(searchType: XHSearchType, preSearchView: UIView?, resultView: UIView?, keywordHandler: @escaping XHSearchKeywordHandler, clearResultHandler: @escaping XHSearchClearResultHandler,cancleHandler: @escaping XHSearchCancleResultHandler) {
        
        self.searchType = searchType
        self.preSearchView = preSearchView
        self.resultView = resultView
        self.keywordHandler = keywordHandler
        self.clearResultHandler = clearResultHandler
        self.cancleHandler = cancleHandler
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeNotification), name: UITextField.textDidChangeNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.textField?.becomeFirstResponder()
        }
    }
    
    @objc private func bigButtonClicked() {
        self.textField?.resignFirstResponder()
    }
    
    @objc private func cancelButtonAction() {
        
        self.textField?.resignFirstResponder()
        self.textField?.text = ""
        self.searchWithKeyWord(keyword: self.textField?.text)
        self.cancleHandler?()
        self.popOrDismissViewController()
    }
    
    func searchWithKeyWord(keyword: String?) {
        if let tempKey = keyword, tempKey.count > 0 {
            if self.searchType == .clickDoneSearch {
                self.textField?.resignFirstResponder()
            }
            
            self.preSearchView?.isHidden = true
            self.resultView?.isHidden = false
            
            if let handler = self.keywordHandler {
                handler(tempKey, self.resultView, self.preSearchView)
            }
        } else {
            self.preSearchView?.isHidden = false
            self.resultView?.isHidden = true
            
            if let handler = self.clearResultHandler {
                handler(self.resultView, self.preSearchView)
            }
        }
    }
}

extension XHSearchViewController {
    private func buildUI() {
        
        let searchBg = UIView()
        searchBg.backgroundColor = UIColor.fromHex("#EFEFF4")
        view.addSubview(searchBg)
        searchBg.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(SpeedyApp.statusBarHeight + 60)
        }
        
        let inputView = UIView()
        inputView.backgroundColor = UIColor.white
        inputView.layerCornerRadius = 6
        searchBg.addSubview(inputView)
        inputView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-62)
            make.bottom.equalTo(-12)
            make.height.equalTo(36)
        }
        
        let searchIcon = UIImageView(imageName: "searchbar_icon_search")
        inputView.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        self.textField = UITextField(text: nil, textColor: UIColor.black, textFont: UIFont.regular(16), placeholder: self.placeholder, placeholderColor: UIColor.fromHex("#B0B2BE"), placeholderFont: UIFont.regular(16), returnKeyType: .search, clearButtonMode: .always, enablesReturnKeyAutomatically: true)
        self.textField?.delegate = self
        self.textField?.contentVerticalAlignment = .center
        inputView.addSubview(self.textField!)
        self.textField?.snp.makeConstraints({ (make) in
            make.left.equalTo(searchIcon.snp.right).offset(8)
            make.top.bottom.right.equalToSuperview()
        })
        
        let cancelBtn = UIButton(title: "取消", titleColor: UIColor.blueColor_xh(), titleFont: UIFont.Semibold(16))
        cancelBtn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        searchBg.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(36)
            make.bottom.equalTo(-12)
            make.right.equalToSuperview()
        }
        
        if let preView = self.preSearchView {
            self.view.addSubview(preView)
            preView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(searchBg.snp.bottom)
            }
            preView.isHidden = false
        }
        
        if let resultV = self.resultView {
            self.view.addSubview(resultV)
            resultV.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(searchBg.snp.bottom)
                make.bottom.equalTo(-SpeedyApp.tabBarBottomHeight)
            }
            resultV.isHidden = true
        }
        
        /*
        // 用于隐藏键盘
        bigBtn = UIButton()
        bigBtn?.addTarget(self, action: #selector(bigButtonClicked), for: .touchUpInside)
        bigBtn?.backgroundColor = UIColor.clear
        view.addSubview(bigBtn!)
        bigBtn?.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.fakeNavBar!.snp.bottom)
        }
        bigBtn?.isHidden = true
        self.view.bringSubview(toFront: searchBg)
 */
    }
}

extension XHSearchViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        self.bigBtn?.isHidden = false
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        self.bigBtn?.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if self.searchType == .clickDoneSearch {
            var searchStr = textField.text
            searchStr = searchStr?.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
            if let tempStr = searchStr, tempStr.count > 0 {
                textField.resignFirstResponder()
                self.searchWithKeyWord(keyword: tempStr)
            } else {
//                self.showError(text: "请输入搜索关键字")
            }
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        self.searchWithKeyWord(keyword: textField.text)
        return true
    }
    
    @objc func textDidChangeNotification() {
        
        if let selectedRange = self.textField?.markedTextRange,
            let newText = self.textField?.text(in: selectedRange), newText.count > 0  {
            return
        }
        
        if self.searchType == .clickDoneSearch {
            if let toBeString = self.textField?.text, toBeString.count > 0 {
                if toBeString.numberOfChars() > 24 {
                    self.textField?.text = toBeString.speedySubString(to: 24)
                }
            } else {
                self.searchWithKeyWord(keyword: "")
            }
        } else {
            self.searchWithKeyWord(keyword: self.textField?.text)
        }
    }
}
