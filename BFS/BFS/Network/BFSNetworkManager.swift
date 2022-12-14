//
//  BFSNetworkManager.swift
//  BFS
//
//  Created by ui03 on 2022/8/29.
//

import UIKit
import Alamofire
import SSZipArchive

class BFSNetworkManager: NSObject {
    
    static let shared = BFSNetworkManager()
    
    func loadAutoUpdateInfo(fileName: String? = nil, urlString: String) {
        AF.download(urlString).downloadProgress { progress in
            print(progress.fractionCompleted)  //进度值
            NotificationCenter.default.post(name: NSNotification.Name.progressNotification, object: nil, userInfo: ["progress": "\(progress.fractionCompleted)", "fileName": fileName])
        }.responseURL { response in
            print(response)
            switch response.result {
            case .success:
                //下载后的文件路径
                if response.fileURL != nil {
                    
                    DispatchQueue.global().async {
                        let path = Bundle.main.bundlePath + "/recommend-app/\(fileName!).bfsa"
                        
                        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                        
                        if fileName != nil, filePath != nil {
                            let desPath = filePath! + "/system-app"
                            SSZipArchive.unzipFile(atPath: path, toDestination: desPath)
                            let schemePath = desPath + "/\(fileName!)/sys/www"   //后面看返回数据修改
                            Schemehandler.setupHTMLCache(fromPath: schemePath)
                            RefreshManager.saveLastUpdateTime(fileName: fileName!, time: Date().timeStamp)
                        }
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name.progressNotification, object: nil, userInfo: ["progress": "complete", "fileName": fileName])
                        }
                    }
                }
            case .failure:
                NotificationCenter.default.post(name: NSNotification.Name.progressNotification, object: nil, userInfo: ["progress": "fail", "fileName": fileName])
            }
        }
    }
    
    func cancelNetworkRequest(urlString: String?) {
        guard urlString != nil else { return }
        AF.session.getTasksWithCompletionHandler { dataTask, uploadTask, downloadTask in
            
            dataTask.forEach { task in
                if task.originalRequest?.url?.absoluteString == urlString {
                    //到时候需要添加取消的id
                    NotificationCenter.default.post(name: NSNotification.Name.progressNotification, object: nil, userInfo: ["progress": "cancel"])
                    task.cancel()
                }
            }
            uploadTask.forEach { task in
                if task.originalRequest?.url?.absoluteString == urlString {
                    NotificationCenter.default.post(name: NSNotification.Name.progressNotification, object: nil, userInfo: ["progress": "cancel"])
                    task.cancel()
                }
            }
            downloadTask.forEach { task in
                if task.originalRequest?.url?.absoluteString == urlString {
                    NotificationCenter.default.post(name: NSNotification.Name.progressNotification, object: nil, userInfo: ["progress": "cancel"])
                    task.cancel()
                }
            }
        }
    }
}
