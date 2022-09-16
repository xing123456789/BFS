//
//  ReadFileManager.swift
//  BFS
//
//  Created by ui03 on 2022/8/26.
//

import UIKit

class ReadFileManager: NSObject {
    
    let bfsAppId: String = "bfs-app-id"
    var linkDict: [String:Any]?
    private var currentJsonName: String = ""
    private var currentVersion: String = ""

    func filePath() -> String {
        return ""
    }
    
    func saveUpdateInfoFilePath() -> String { return "" }
    
    //读取bfs-app-id 的link文件信息
    func readBFSAppLinkContent() -> [String:Any]? {
        let path = filePath() + "/\(bfsAppId)/boot/link.json"
        let manager = FileManager.default
        guard let data = manager.contents(atPath: path) else { return nil }
        guard let content = String(data: data, encoding: .utf8) else { return nil }
        let linkDict = ConverUnits.converStringToDictionary(text: content)
        return linkDict
    }
    
    //读取autoUpdate信息
    func readAutoUpdateInfo() -> (Int?, String?){
        
        let linkDict = readBFSAppLinkContent()
        guard let updateDict = linkDict?["autoUpdate"] as? [String:Any] else {
            return (nil,nil)
        }
        let maxAge = updateDict["maxAge"] as? Int
        let url = updateDict["url"] as? String
        return (maxAge,url)
    }
    
    //读取轮询更新缓存信息  取文件夹下面的很多文件
    func readCacheUpdateInfo() -> [String:Any]? {
        let filePath = saveUpdateInfoFilePath()
        let updatePath = filePath + "/\(bfsAppId)/tmp/autoUpdate/"
        let manager = FileManager.default
        let subContents = try? manager.contentsOfDirectory(atPath: updatePath).sorted { $0 > $1 }
        guard let first = subContents?.first else { return nil }
        let path = updatePath + first
        guard let data = manager.contents(atPath: path) else { return nil }
        guard let cacheString = String(data: data, encoding: .utf8) else { return nil }
        return ConverUnits.converStringToDictionary(text: cacheString)
    }
    
    
    //写入轮询更新的机制信息
    func writeUpdateInfoToTmpFile(json: [String:Any]) {
        let filePath = saveUpdateInfoFilePath()
        var updatePath = filePath + "/\(bfsAppId)/tmp/autoUpdate/"
        if !FileManager.default.fileExists(atPath: updatePath) {
            try? FileManager.default.createDirectory(atPath: updatePath, withIntermediateDirectories: true)
        }
        var currentTime = Date().dateToString(identifier: "UTC")
        currentTime = currentTime.replacingOccurrences(of: ":", with: "")
        currentTime = currentTime.replacingOccurrences(of: " ", with: "")
        updatePath = updatePath + "\(currentTime).json"
        currentJsonName = "\(currentTime).json"
        currentVersion = json["version"] as? String ?? ""
        let jsonString = ConverUnits.converDictionaryToString(dict: json)
        guard jsonString.count > 0 else { return }
        if !FileManager.default.fileExists(atPath: updatePath) {
            FileManager.default.createFile(atPath: updatePath, contents: nil)
        }
        try? jsonString.write(toFile: updatePath, atomically: true, encoding: .utf8)
        
    }
    
    func isNewUpdateInfo() -> Bool {
        let filePath = filePath()
        let updatePath = filePath + "/\(bfsAppId)/tmp/autoUpdate/"
        var subContents = try? FileManager.default.contentsOfDirectory(atPath: updatePath).sorted { $0 > $1 }
        guard subContents != nil else { return true }
        if let index = subContents!.firstIndex(of: currentJsonName) {
            subContents!.remove(at: index)
        }
        if let first = subContents!.first {
            let versionPath = updatePath + first
            if let data = FileManager.default.contents(atPath: versionPath) {
                if let cacheString = String(data: data, encoding: .utf8) {
                    let oldDict = ConverUnits.converStringToDictionary(text: cacheString)
                    let version = oldDict?["version"] as? String ?? ""
                    let versionDouble = Double(version) ?? 0
                    let currentDouble = Double(currentVersion) ?? 0
                    if currentDouble > versionDouble {
                        return true
                    } else {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func updateFilePath() -> String {
        guard let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return "" }
        return filePath
    }
    
    func iconImage() -> UIImage? { return nil }
    
    func appName() -> String {
        if linkDict == nil {
            linkDict = readBFSAppLinkContent()
        }
        return linkDict?["name"] as? String ?? ""
    }
    
    
    
    ////////////////////////
    //读取system-app文件夹下面的文件夹
    func readAppSubFile() -> [String] {
        return subFilePathNames(atPath: filePath())
    }
    
    //读取文件夹下面的第一级文件夹
    private func subFilePathNames(atPath path: String) -> [String] {
        var fileList: [String] = []
        guard let filePaths = FileManager.default.subpaths(atPath: path) else { return fileList }
        for fileName in filePaths {
            var isDir: ObjCBool = true
            let fullPath = "\(path)/\(fileName)"
            if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                if !isDir.boolValue {
                    
                } else {
                    //后续是不需要判断.的，因为这是临时添加的，后续从网络获取
                    if !fileName.contains("/"), !fileName.contains(".") {
                        fileList.append(fileName)
                    }
                }
            }
        }
        return fileList
    }
    
    func appIconImage(fileName: String) -> UIImage? { return nil }
    func appName(fileName: String) -> String? { return nil }
}
