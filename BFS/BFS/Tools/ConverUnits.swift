//
//  ConverUnits.swift
//  BFS
//
//  Created by ui03 on 2022/8/26.
//

import UIKit

class ConverUnits: NSObject {

    static func converStringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
               return try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func converDictionaryToString(dict: [String:Any]) -> String {
        var result: String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                result = jsonString
            }
        } catch {
            result = ""
        }
        return result
    }
}
