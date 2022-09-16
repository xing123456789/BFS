//
//  RecommendFileManager.swift
//  BFS
//
//  Created by ui03 on 2022/8/26.
//

import UIKit

class RecommendFileManager: ReadFileManager {

    override func filePath() -> String {
        return Bundle.main.bundlePath + "/recommend-app"
    }
    
    override func saveUpdateInfoFilePath() -> String {
        return NSHomeDirectory() + "/recommend-app"
    }
    
    override func iconImage() -> UIImage? {
        
        if linkDict == nil {
            linkDict = readBFSAppLinkContent()
        }
        let imageName = linkDict?["icon"] as? String ?? ""
        let imagePath = filePath() + "/bfs-app-id/sys/" + imageName
        let image = UIImage(contentsOfFile: imagePath)
        return image
    }
    
    
    override func appIconImage(fileName: String) -> UIImage? {
        
        return nil
    }
    
    
    
 
    
}
