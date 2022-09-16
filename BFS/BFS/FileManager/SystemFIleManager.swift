//
//  SystemFileManager.swift
//  BFS
//
//  Created by ui03 on 2022/8/26.
//

import UIKit

class SystemFileManager: ReadFileManager {

    
    override func filePath() -> String {
        return NSHomeDirectory() + "/system-app"
    }
    
    override func saveUpdateInfoFilePath() -> String {
        return NSHomeDirectory() + "/system-app"
    }
    
    override func iconImage() -> UIImage? {
        if linkDict == nil {
            linkDict = readBFSAppLinkContent()
        }
        let imageName = linkDict?["icon"] as? String ?? ""
        let path = filePath() + "/\(bfsAppId)/boot/"
        let imagePath = path + imageName
        if FileManager.default.fileExists(atPath: imagePath) {
            print("haha")
        }
        let image = UIImage(contentsOfFile: imagePath)
        return image
    }
    
    //读取matedata.json文件
    func readBFSAMatedataContent() -> [String:Any]? {
        let path = filePath() + "/boot/bfsa-matedata.json"
        let manager = FileManager.default
        guard let data = manager.contents(atPath: path) else { return nil }
        guard let content = String(data: data, encoding: .utf8) else { return nil }
        let mateDict = ConverUnits.converStringToDictionary(text: content)
        return mateDict
    }
    
    //读取sys文件夹
    func readBFSASysFile() {
        let path = filePath() + "/sys"
        let manager = FileManager.default
        guard let data = manager.contents(atPath: path) else { return }
        guard let content = String(data: data, encoding: .utf8) else { return }
        let mateDict = ConverUnits.converStringToDictionary(text: content)
    }
}
