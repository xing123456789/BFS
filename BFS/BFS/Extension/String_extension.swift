//
//  String_extension.swift
//  BFS
//
//  Created by ui03 on 2022/9/14.
//

import Foundation

extension String {
    
    func versionCompare(oldVersion: String) -> ComparisonResult {
        
        let delimiter = "."
        var currentComponents = self.components(separatedBy: delimiter)
        var oldComponents = oldVersion.components(separatedBy: delimiter)
        
        let diff = currentComponents.count - oldComponents.count
        let zeros = Array(repeating: "0", count: abs(diff))
        if diff > 0 {
            oldComponents.append(contentsOf: zeros)
        } else if diff < 0 {
            currentComponents.append(contentsOf: zeros)
        }
        
        for i in stride(from: 0, to: currentComponents.count, by: 1) {
            let current = currentComponents[i]
            let old = oldComponents[i]
            if Int(current)! > Int(old)! {
                return .orderedAscending
            } else if Int(current)! < Int(old)! {
                return .orderedDescending
            }
        }
        return .orderedDescending
    }
}
