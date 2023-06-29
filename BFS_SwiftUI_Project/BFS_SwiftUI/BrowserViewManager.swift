//
//  BrowserView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/6/20.
//

import UIKit
import SwiftUI
import WebKit

@objc(BrowserViewManager)
public class BrowserViewManager: NSObject {
    
    @objc public var browserView: UIView?
    
    public typealias initNewWebView = (WKWebViewConfiguration?) -> WKWebView
    public static var webviewGenerator: initNewWebView?
    
    public typealias clickAppCallback = (String) -> Void
    private var clickCallback: clickAppCallback?
    
    @objc public override init() {
        super.init()
        
        let controller = UIHostingController(rootView: BrowserContentView().environment(\.managedObjectContext, DataController.shared.container.viewContext))
        
        self.browserView = controller.view
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "OpenApp"), object: nil, queue: .main) { noti in
            guard let urlString = noti.object as? String else { return }
            self.clickCallback?(urlString)
        }
    }
    
    
    @objc public static func webviewGeneratorCallback(callback: @escaping initNewWebView) {
        webviewGenerator = callback
    }
    
    @objc public func clickAppAction(callback: @escaping clickAppCallback) {
        self.clickCallback = callback
    }
}
