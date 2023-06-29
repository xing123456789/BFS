//
//  SecondWebView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/6/17.
//

import SwiftUI
import WebKit

struct SecondWebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let webView: WKWebView
    private var id: String = ""
    private var urlString: String = ""
    
    init(id: String, urlString: String, webView: WKWebView) {
        print("webview init")
        self.id = id
        self.urlString = urlString
        self.webView = webView
        
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    class Coordinator: NSObject, WKNavigationDelegate {

        var parent: SecondWebView

        init(parent: SecondWebView) {
            self.parent = parent
            
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("scrolling offset: \(scrollView.contentOffset.y)")
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
            NotificationCenter.default.post(name: Notification.Name.webViewTitle, object: nil, userInfo: ["title": title, "urlString": urlString])
            
//            saveToHistoryCoreData(urlString: urlString, title: title)
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
    }
}

class SecondCacheWebView {
    
    static let shared = SecondCacheWebView()
    private var webDict: [String: WebViewWrapper] = [:]
    
    func saveWebViewWrapper(wrapper: WebViewWrapper, id: String) {
        webDict[id] = wrapper
    }
    
    func webViewWrapper(for id: String) -> WebViewWrapper {
        if let wrapper = webDict[id] {
            return wrapper
        }
        let wrapper = WebViewWrapper(id: id)
        webDict[id] = wrapper
        return wrapper
    }
    
    func removeCacheWebViewWrapper() {
        webDict.removeAll()
    }
    
    func webViewWrapperLists() -> [WebViewWrapper] {
        return [WebViewWrapper](webDict.values)
    }
}
