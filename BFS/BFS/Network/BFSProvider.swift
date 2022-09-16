//
//  BFSProvider.swift
//  BFS
//
//  Created by ui03 on 2022/8/26.
//

import Foundation
import Moya

public enum BFSType {
    case downloadFile
}

extension BFSType: TargetType {
    
    public var path: String {
        switch self {
        case .downloadFile:
            return "/assett"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .downloadFile:
            return .get
        }
    }
    
    public var task: Task {
        
        switch self {
        case .downloadFile:
            return .downloadDestination(DefaultDownloadDestination)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var baseURL: URL {
        switch self {
        case .downloadFile:
            return URL(string: "https://www.douban.com")!
        }
    }
    
    public var validate: Bool {
        return false
    }
    
    public var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
}

//定义下载的DownloadDestination（不改变文件名，同名文件不会覆盖）
private let DefaultDownloadDestination: DownloadDestination = { temporaryURL, response in
    return (DefaultDownloadDir.appendingPathComponent(RecommendTmpPath), [.removePreviousFile])
}
 
//默认下载保存地址（用户文档目录）
let DefaultDownloadDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()
