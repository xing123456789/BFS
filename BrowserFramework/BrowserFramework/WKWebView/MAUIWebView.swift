//
//  TestSwiftUIWebView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/6/20.
//

import SwiftUI
import WebKit

struct MAUIWebView: UIViewRepresentable {
    
    typealias UIViewType = WKWebView
    
    var urlString: String = ""
    
    var id: String = ""
    
    init(id: String, urlString: String) {
  
        self.urlString = urlString
        self.id = id
    }
  
    
    func makeUIView(context: Context) -> WKWebView {
        
        var webView = BrowserViewManager.webviewGenerator!(nil)
        if CacheWebView.shared.webView(for: id) != nil {
            webView = CacheWebView.shared.webView(for: id)!
        } else {
            CacheWebView.shared.saveWebView(webView: webView, id: id)
        }
        webView.configuration.mediaTypesRequiringUserActionForPlayback = .all
        webView.configuration.allowsInlineMediaPlayback = false
        webView.navigationDelegate = context.coordinator
        webView.scrollView.keyboardDismissMode = .onDrag
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "stopScroll"), object: nil, queue: .main) { noti in
            guard let obj = noti.object as? String else { return }
            
            if obj == "start" {
                webView.scrollView.isScrollEnabled = true
            } else {
                webView.scrollView.isScrollEnabled = false
                let scrolloffset = webView.scrollView.contentOffset
                webView.scrollView.setContentOffset(scrolloffset, animated: false)
            }
        }
        return webView
    }
    
    func createWebView(context: Context) -> WKWebView {
        
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        config.mediaTypesRequiringUserActionForPlayback = .all
        config.allowsInlineMediaPlayback = false
        config.allowsAirPlayForMediaPlayback = false
        let prefreen = WKPreferences()
        prefreen.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = prefreen
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 150), configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: MAUIWebView
        
        init(parent: MAUIWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            print("navigationAction")
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            print("navigationResponse")
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("didStartProvisionalNavigation")
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("didCommit")
            
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("didFinish")
            let urlString = webView.url?.absoluteString ?? ""
            let title = webView.title ?? ""
            guard urlString.count > 0, title.count > 0 else { return }
            NotificationCenter.default.post(name: Notification.Name.webViewTitle, object: nil, userInfo: ["title": title, "id": self.parent.id])
            
            saveToHistoryCoreData(urlString: urlString, title: title)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("didFailProvisionalNavigation")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("didFail")
        }
        
        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            print("didReceiveServerRedirectForProvisionalNavigation")
        }
        
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            print("webViewWebContentProcessDidTerminate")
        }
        
        //保存到数据库
        private func saveToHistoryCoreData(urlString: String, title: String) {
            let incognitoMode = UserDefaults.standard.bool(forKey: "incognitoMode")
            guard !incognitoMode else { return }
            let manager = HistoryCoreDataManager()
            let link = LinkRecord(link: urlString, imageName: "", title: title, createdDate: Date().milliStamp)
            manager.insertHistory(history: link)
        }
    }
}

class CacheWebView {
    
    static let shared = CacheWebView()
    private var webDict: [String: WKWebView] = [:]
    
    func saveWebView(webView: WKWebView, id: String) {
        webDict[id] = webView
    }
    
    func webView(for id: String) -> WKWebView? {
        return webDict[id]
    }
    
    func removeCacheWebView() {
        webDict.removeAll()
    }
    
    func webLists() -> [WKWebView] {
        return [WKWebView](webDict.values)
    }
}
