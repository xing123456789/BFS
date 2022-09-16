//
//  EncryptUnits.swift
//  BFS
//
//  Created by ui03 on 2022/8/29.
//

import UIKit
import CommonCrypto

class EncryptUnits: NSObject {
    
    static func MD5(text: String) -> String {
        
        guard let data = text.data(using: .utf8) else { return text }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        #if swift(>=5.0)
        
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
         }
        
        #else
        
        _ = data.withUnsafeBytes { bytes in
             return CC_MD5(bytes, CC_LONG(data.count), &digest)
        }
        
        #endif
        
        return digest.map { String(format: "%02x", $0) }.joined()
        
    }
}
