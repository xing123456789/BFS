//
//  Image_extension.swift
//  BrowserFramework
//
//  Created by ui03 on 2023/6/21.
//

import UIKit

extension UIImage {
    
    static func bundleImage(name: String) -> UIImage {
        let bundle = Bundle(for: BrowserViewManager.self)
        print(name)
        let image = UIImage(named: "Resoures.bundle/\(name).png", in: bundle, compatibleWith: nil)
        print(image)
        return image!
    }

}
