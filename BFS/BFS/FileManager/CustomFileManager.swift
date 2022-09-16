//
//  CustomFileManager.swift
//  BFS
//
//  Created by ui03 on 2022/8/26.
//

import UIKit
import RxSwift

enum FilePathType {
    case system
    case recommend
    case none
}

/**
 1、点击图标，获取app类型
 2、如果是system-app 则直接跳转到网页
 3、如果是recommend-app，开始网络请求，并把结果保存到system-app文件夹下面
 */

let customFileManager = CustomFileManager()

class CustomFileManager: NSObject {

    //当前app类型
    private var fileType: FilePathType = .none
    private var linkDict: [String:Any]?
    private let sysManager = SystemFileManager()
    private let recommendManager = RecommendFileManager()
    private var currentUrlString: String?
    private let disposeBag = DisposeBag()
    
    var appName: String {
        if fileType == .system {
            return sysManager.appName()
        } else if fileType == .recommend {
            return recommendManager.appName()
        }
        return ""
    }
    
    var appIcon: UIImage? {
        if fileType == .system {
            return sysManager.iconImage()
        } else if fileType == .recommend {
            return recommendManager.iconImage()
        }
        return nil
    }
    //初始化
    func initFileManager() {
        readFileContent()
        let updateInfo = updateInfo().0
        GlobalTimer.shared.StartTimer()
//        NotificationCenter.default.addObserver(self, selector: #selector(downloadNewFile), name: NSNotification.Name.init(rawValue: "update"), object: nil)
        
        operateMonitor.refreshCompleteMonitor.subscribe(onNext: { [weak self] name in
            guard let strongSelf = self else { return }
            strongSelf.downloadNewFile()
        }).disposed(by: disposeBag)

    }
    //更新信息下载完后，重新下载项目文件
    @objc func downloadNewFile() {
        //3、如果有最新信息，停止缓存中的更新
        guard hasNewUpdateInfo() else { return }
        //4再从从bfs-app-id/tmp/autoUpdate/缓存中读取最新的json数据
        guard let newURLString = refreshInfoFromCacheInfo() else { return }
        if currentUrlString == nil {
            BFSNetworkManager.shared.loadAutoUpdateInfo(urlString: newURLString)
        } else {
            //5、重新下载
            reloadUpdateFile(cancelUrlString: currentUrlString, urlString: newURLString)
        }
    }
    
    func clickAPPAction(callback: @escaping (FilePathType) -> Void) {
        readFileContent()
        if fileType == .system {
            //点击system 跳转到二级界面，加载本地数据
            callback(.system)
        } else {
            //点击recommend
            callback(.recommend)
            //1、从bfs-app-id/tmp/autoUpdate/缓存中读取当下的新json数据,并请求更新
            let cancelURLString = refreshInfoFromCacheInfo()
            alertUpdateViewController(urlstring: cancelURLString)
            currentUrlString = cancelURLString
 
            /**
             1、读取缓存的json信息，基于autoUpdate->url->files->url字段加载
             2、弹框，用户确认是否下载
             3、点击“取消”，更新autoUpdate->url轮询的信息
             4、点击“确认”
                4.1、如果第一步没有缓存字段
                    4.1.1、更新autoUpdate->url轮询的信息
                    4.1.2、下载项目文件
                4.2、如果第一步取出缓存字段
                    4.2.1、更新autoUpdate->url轮询的信息
                    4.2.2、依缓存路径，下载项目文件
                    4.2.3、判断下载的轮询信息是否有新内容
                    4.2.4、如果有，取消4.2.2的下载，按最新下载地址下载项目文件
             */
        }
    }
    
    //更新类型
    func updateFileType() {
        fileType = .system
    }
    
    //读取更新的信息
    func updateInfo() -> (Int?, String?) {
        if fileType == .system {
            return sysManager.readAutoUpdateInfo()
        } else if fileType == .recommend {
            return recommendManager.readAutoUpdateInfo()
        }
        return (nil,nil)
    }
    
    //读取缓存更新的信息
    func cacheUpdateInfo() -> [String:Any]? {
        if fileType == .system {
            return sysManager.readCacheUpdateInfo()
        } else if fileType == .recommend {
            return recommendManager.readCacheUpdateInfo()
        }
        return nil
    }
    
    //写入轮询更新数据
    func writeUpdateContent(json: [String:Any]?) {
        guard json != nil else { return }
        if fileType == .system {
            sysManager.writeUpdateInfoToTmpFile(json: json!)
        } else if fileType == .recommend {
            recommendManager.writeUpdateInfoToTmpFile(json: json!)
        }
    }
    
    //从bfs-app-id/tmp/autoUpdate/缓存中读取json数据,并请求更新数据
    private func refreshInfoFromCacheInfo() -> String? {
        let cacheInfo = cacheUpdateInfo()
        let fileInfo = cacheInfo?["files"] as? [String:Any]
        guard let urlstring = fileInfo?["url"] as? String else { return nil }
        return urlstring
    }
    
    //从link.json的autoUpdate读取更新信息
    private func refreshNewAutoUpdateInfo(isCompare: Bool) {
        guard let updateString = updateInfo().1 else { return }
        let refreshManager = RefreshManager()
        refreshManager.loadUpdateRequestInfo(urlString: updateString, isCompare: isCompare)
    }
    
    //判断是否有新的更新消息
    private func hasNewUpdateInfo() -> Bool {
        if fileType == .system {
            return sysManager.isNewUpdateInfo()
        } else if fileType == .recommend {
            return recommendManager.isNewUpdateInfo()
        }
        return true
    }
    
    //取消缓存的下载信息，重新下载最新信息
    private func reloadUpdateFile(cancelUrlString: String?, urlString: String?) {
        BFSNetworkManager.shared.cancelNetworkRequest(urlString: cancelUrlString)
        if urlString != nil {
            BFSNetworkManager.shared.loadAutoUpdateInfo(urlString: urlString!)
        }
    }
    
    //获取system-app链接
    private func systemMatedataEnterURLString() -> String {
        let mateDict = sysManager.readBFSAMatedataContent()
        let enterDict = mateDict?["enter"] as? [String:String]
        let enterUrl = enterDict?["main"] ?? ""
        return enterUrl
    }
    
    //判断当前app类型
    private func readFileContent() {
        let path = sysManager.filePath()
        guard let filePaths = FileManager.default.subpaths(atPath: path) else {
            fileType = .recommend
            return }
        if filePaths.count > 0  {
            fileType = .system
        } else {
            fileType = .recommend
        }
    }
    
    //读取system-app信息
    private func readSystemFileContent() -> [String:Any]? {
        return sysManager.readBFSAppLinkContent()
    }
    
    //读取recommond-app信息
    private func readRecommondFileContent() -> [String:Any]? {
        return recommendManager.readBFSAppLinkContent()
    }
    
    //获取link信息
    private func readLinkInfo() {
        if fileType == .system {
            linkDict = readSystemFileContent()
        } else if fileType == .recommend {
            linkDict = readRecommondFileContent()
        }
    }
    
    //下载弹框
    private func alertUpdateViewController(urlstring: String?) {
        let alertVC = UIAlertController(title: "确认下载更新吗？", message: nil, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确认", style: .default) { action in
            if urlstring != nil {
                BFSNetworkManager.shared.loadAutoUpdateInfo(urlString: urlstring!)
            }
            self.refreshNewAutoUpdateInfo(isCompare: true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
            self.refreshNewAutoUpdateInfo(isCompare: false)
        }
        alertVC.addAction(sureAction)
        alertVC.addAction(cancelAction)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let controller = appDelegate.window?.rootViewController
        controller?.present(alertVC, animated: true)
    }
}
