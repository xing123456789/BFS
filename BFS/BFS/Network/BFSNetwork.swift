//
//  BFSNetwork.swift
//  BFS
//
//  Created by ui03 on 2022/8/26.
//

import Foundation
import Moya
import SwiftyJSON
import SSZipArchive

struct BFSNetwork {
    
    static let provider = MoyaProvider<BFSType>()
    
    static func request(_ target: BFSType,
                        success successCallback: @escaping (JSON) -> Void,
                        error errorCallback: @escaping (Int) -> Void,
                        fail failCallback: @escaping (MoyaError) -> Void) {
        
        provider.request(target) { progress in
            if target == .downloadFile {
                print(progress.progress)
                NotificationCenter.default.post(name: NSNotification.Name.progressNotification, object: nil, userInfo: ["progress": progress.progress])
            }
        } completion: { result in
            switch result {
            case .success:
                if target == .downloadFile {
                    //下载后的文件路径
                    let location = DefaultDownloadDir.appendingPathComponent(RecommendTmpPath)
                    let desPath = Bundle.main.bundlePath + "/system-app"
                    SSZipArchive.unzipFile(atPath: location.path, toDestination: desPath)
                }
            case let .failure(error):
                print(error.errorCode)
            }
        }
    }
}
