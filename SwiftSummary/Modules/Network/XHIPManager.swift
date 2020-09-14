//
//  XHIPManager.swift
//  XCamera
//
//  Created by Quinn Von on 2019/11/25.
//  Copyright © 2019 xhey. All rights reserved.
//

/*
import Foundation
import Alamofire

class XHIPManager {
    
    static let shared: XHIPManager = XHIPManager()
    
    // path: index
    var retryDic:[String: Int] = [:] //重试次数
    var ip_index_Dic:[String: Int] = [:] //当前ip索引
    
    var timeOut: TimeInterval {
        let timeOut = UserDefaults.standard.integer(forKey: "XHIPManager.shared.currentTimeOut")
        if timeOut > 5{
            return TimeInterval(timeOut)
        }else{
            return 60
        }
    }
    
    var currentIndex = 0
    
    // 真实账号的ip列表
    var realAccountIpList: [String] = defaultRealAccountIpList
    
    // 体验账号的ip列表
    var tryAccountIpList: [String] = defaultTryAccountIpList
    
    
    private init() {
        configIpList()
    }
    
    // MARK: - 配置ip列表
    func configIpList(server: ServerIP? = nil) {
        
        var currentServer = server
        if currentServer == nil {
            currentServer = getServerIPFromSandbox()
        }
        
        // 真实账号
        var realList: [String] = []
        if let tempList = currentServer?.server_ip_list, tempList.count > 0 {
            for tempIp in tempList {
                if tempIp.count > 0 {
                    realList.append(tempIp)
                }
            }
        }
        
        self.realAccountIpList.removeAll()
        if realList.count > 0 {
            let domainName = XHeyUseTestSever ? "test.xhey.top" : "today.xhey.top"
            realList.append(domainName)
            for tempIp in realList {
                self.realAccountIpList.append(tempIp)
            }
        } else {
            for tempIp in defaultRealAccountIpList {
                self.realAccountIpList.append(tempIp)
            }
        }
        
        // 体验账号
        var tryList: [String] = []
        if let tempList = currentServer?.try_server_ip_list, tempList.count > 0 {
            for tempIp in tempList {
                if tempIp.count > 0 {
                    tryList.append(tempIp)
                }
            }
        }
        
        self.tryAccountIpList.removeAll()
        if tryList.count > 0 {
            let domainName = XHeyUseTestSever ? "testtry.xhey.top" : "prodtry.xhey.top"
            tryList.append(domainName)
            for tempIp in tryList {
                self.tryAccountIpList.append(tempIp)
            }
        } else {
            for tempIp in defaultTryAccountIpList {
                self.tryAccountIpList.append(tempIp)
            }
        }
        
        //ip 列表发生变化时，currentIndex 默认取第一个个
        let index = UserDefaults.standard.integer(forKey: "XHIPManager.shared.currentIndex")
        currentIndex = index
        
        let ipList = self.getCurrentUseIpList(path: nil)
        if currentIndex >= ipList.count{
            currentIndex = 0
        }
    }
    
    /*
    //是否是域名
    func isDomain_name(path: String) -> Bool{
        
        let currentUrl = buildUrl(by: path)
        for name in defaultDomainNames {
            if currentUrl.contains(name) {
                return true
            }
        }
        return false
    }
 */
    
    //更新默认索引值
    func update_default_ip(path: String) {
        if let index = ip_index_Dic[path]{
            currentIndex = index
            UserDefaults.standard.set(currentIndex, forKey: "XHIPManager.shared.currentIndex")
        }
        
        self.retryDic[path] = 1
        self.ip_index_Dic[path] = nil
    }
    
    // 获取某个接口当前的ip索引值
    private func getIpIndex(path: String) -> Int {
        if let index = ip_index_Dic[path]{
            return index
        }else{
            return currentIndex
        }
    }
    
    // 更新某个接口当前的ip索引值
    func updateIpIndex(path: String) {
        if let index = ip_index_Dic[path]{
            ip_index_Dic[path] = index + 1
        }else{
            ip_index_Dic[path] = currentIndex + 1
        }
    }
    
    // 构建Url， 获取主机名+路径（hostname+path）
    func buildUrl(by path: String) -> String {
        
        let currentIpList = self.getCurrentUseIpList(path: path)
        let _index = getIpIndex(path: path)
        let index = (_index)%(currentIpList.count)
        let hostname = currentIpList[index] // 主机名(hostname)
        let path = "/next/\(path)" // 绝对路径（path）
        
        // 协议 + 主机名(hostname) + 绝对路径（path）
        let currentUrl = "https://" + hostname + path
        XHLogDebug("[IP调试] - 构建Url:[\(currentUrl)]")
        
        ////////
        // 测试代码，上线注释掉
//        XHDebugTool.shared.showDebugToast(currentUrl)
        ////////
        
        return currentUrl
    }
    
    // 上报埋点的时候使用，获取主机名（可能是域名也可能是ip地址）
    func getReportHostname(by path: String) -> String {
        
        let currentIpList = self.getCurrentUseIpList(path: path)
        let _index = getIpIndex(path: path)
        let index = (_index)%(currentIpList.count)
        
        let resultStr = currentIpList[index]
        XHLogDebug("[IP调试] - 上报埋点的时候使用，获取主机名 - path:[\(path)] - domainName:[\(resultStr)]")
        return resultStr
    }
    
    // 获取当前使用的ip列表
    func getCurrentUseIpList(path: String?) -> [String] {
        
        var resultList: [String] = []
        
        if XHUserManager.shared.isTryAccount {
            resultList = self.tryAccountIpList
        } else {
            resultList = self.realAccountIpList
        }
        
        // 过滤白名单
        if let currentPath = path, currentPath.count > 0 {
            // 必须使用体验账号的ip
            if mustUseTryAccountIpList.contains(currentPath) {
                resultList = self.tryAccountIpList
            }
            
            // 必须使用真实账号的ip
            if mustUseRealAccountIpList.contains(currentPath) {
                resultList = self.realAccountIpList
            }
        }
        
        return resultList
    }
    
    // MARK: - 获取主机名(next:用于标识接口是否加密)
    func getHostname() -> String {
        var resultStr = ""
        if XHUserManager.shared.isTryAccount {
            resultStr = XHeyUseTestSever ? "120.25.230.142" : "47.112.157.77"
            
            if self.tryAccountIpList.count > 0 {
                let index = (currentIndex) % (tryAccountIpList.count)
                resultStr = tryAccountIpList[index]
            }
            XHLogDebug("[IP调试] - 体验账号的ip - currentIndex:[\(currentIndex)] - ip:[\(resultStr)]")
        } else {
            resultStr = XHeyUseTestSever ? "119.23.165.102": "47.112.75.234"
            if self.realAccountIpList.count > 0 {
                let index = (currentIndex) % (realAccountIpList.count)
                resultStr = realAccountIpList[index]
            }
            XHLogDebug("[IP调试] - 真实账号的ip - currentIndex:[\(currentIndex)] - ip:[\(resultStr)]")
        }
        return "\(resultStr)/next"
    }
}

// MARK: - 保存获取数据
extension XHIPManager {
    
    // MARK: - 保存ip列表
    func saveServerIP(server: ServerIP?){
        
        // 设置超时时间
        let timeout = Int(server?.timeout_seconds ?? 60)
        UserDefaults.standard.set(timeout, forKey: "XHIPManager.shared.currentTimeOut")
        
        guard let s = server else {
            XHLogDebug("[IP调试] - 保存ServerIP失败，因为传过来的值是空的")
            return
        }
        let data = try? JSONEncoder().encode(s)
        let path = SpeedySandbox.shared.cachesDirectory + (XHeyUseTestSever ? "/serverTestIP" : "/serverIP")
        let url = URL(fileURLWithPath: path)
        
        do {
            try data?.write(to: url)
            XHLogDebug("[IP调试] - 保存ServerIP到沙盒成功")
        } catch  {
            XHLogDebug("[IP调试] - 保存ServerIP到沙盒失败, error:[\(error)]")
        }
        configIpList(server: server)
    }
    
    // MARK: - 从沙盒获取ip列表成功
    private func getServerIPFromSandbox() -> ServerIP? {
        let path = SpeedySandbox.shared.cachesDirectory + (XHeyUseTestSever ? "/serverTestIP" : "/serverIP")
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url), let server = try? JSONDecoder().decode(ServerIP.self, from: data) {
            XHLogDebug("[IP调试] - 从沙盒获取ip列表成功")
            return server
        }
        XHLogDebug("[IP调试] - 从沙盒获取ip列表失败")
        return nil
    }
}

 */
