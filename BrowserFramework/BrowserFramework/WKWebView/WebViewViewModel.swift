//
//  WebViewViewModel.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/4/24.
//

import SwiftUI
import WebKit

enum ScrollDirection {
    case none
    case up
    case down
}

final class WebViewViewModel: NSObject, ObservableObject, Identifiable {
    
    var id = UUID().uuidString
    var webView: WKWebView!
    
    private var progressToken: NSKeyValueObservation?
    
    private var backToken: NSKeyValueObservation?
    
    private var forwardToken: NSKeyValueObservation?
    
    private var startOffsetY: CGFloat = 0
    private var endDragging = false
    private var isScroll = false
    private var direction: ScrollDirection = .none
    private let defaultOffset: CGFloat = 35
    
    init(webView: WKWebView? = nil, jsNames: [String]? = nil, messageHandles: [String]? = nil, replyHandles: [String]? = nil) {
        super.init()
        
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        addUserScript(userContentController: config.userContentController, jsNames: jsNames)
        addMessageHandles(userContentController: config.userContentController, messageHandles: messageHandles)
        addMessageReplyHandles(userContentController: config.userContentController, replyHandles: replyHandles)
        
        let prefreen = WKPreferences()
        prefreen.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = prefreen
        if webView == nil {
            self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 150), configuration: config)
        } else {
            self.webView = webView
        }
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
//        self.webView.scrollView.delegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.scrollView.keyboardDismissMode = .onDrag
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {

        }
        addWebViewObserver()
    }
}

extension WebViewViewModel {
    
    func loadUrl(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func cancelLodUrl() {
        webView.stopLoading()
    }
    
    func addWebViewObserver() {
        
        progressToken = webView.observe(\.estimatedProgress, options: .new) { view, change in
            let progress = Float(change.newValue ?? 0)
            NotificationCenter.default.post(name: Notification.Name.progress, object: nil, userInfo: ["progress":progress])
        }
        
        backToken = webView.observe(\.canGoBack, options: .new) { view, change in
            NotificationCenter.default.post(name: Notification.Name.goBack, object: nil, userInfo: ["goBack":change.newValue ?? false])
        }
        
        forwardToken = webView.observe(\.canGoForward, options: .new) { view, change in
            NotificationCenter.default.post(name: Notification.Name.goForward, object: nil, userInfo: ["goForward":change.newValue ?? false])
        }
    }
    
    func removeWebViewObserver() {
//        progressToken?.invalidate()
//        backToken?.invalidate()
//        forwardToken?.invalidate()
//        NotificationCenter.default.removeObserver(self)
    }
    
    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
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

extension WebViewViewModel {
    
    //注入脚本
    private func addUserScript(userContentController: WKUserContentController, jsNames: [String]?) {
        guard let jsNames = jsNames,jsNames.count > 0 else { return }
        for jsName in jsNames {
          let path = Bundle.main.bundlePath + "/JSScript/" +  jsName + ".js"  //js脚本统一放到JSScript文件夹中
            let url = URL(fileURLWithPath: path)
            let data = try? Data(contentsOf: url)
            if data != nil {
                if let jsString = String(data: data!, encoding: .utf8) {
                    let script = WKUserScript(source: jsString, injectionTime: .atDocumentStart, forMainFrameOnly: true)
                    userContentController.addUserScript(script)
                }
            }
        }
    }
    
    //添加js交互
    private func addMessageHandles(userContentController: WKUserContentController, messageHandles: [String]?) {
        guard let handles = messageHandles, handles.count > 0 else { return }
        for name in handles {
            userContentController.add(LeadScriptHandle(messageHandle: self), name: name)
        }
    }
    
    //添加js交互,并返回数据给js
    private func addMessageReplyHandles(userContentController: WKUserContentController, replyHandles: [String]?) {
        guard let handles = replyHandles, handles.count > 0 else { return }
        for name in handles {
            userContentController.addScriptMessageHandler(LeadReplyHandle(messageHandle: self), contentWorld: .page, name: name)
        }
    }
}

//js 和原生交互
extension WebViewViewModel:  WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}

//js 和原生交互 并返回结果给js
extension WebViewViewModel:  WKScriptMessageHandlerWithReply {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
        
    }

}


extension WebViewViewModel: WKNavigationDelegate {
    
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
    
}

/*
var lastOffset: CGPoint = .zero

extension WebViewViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
  
        if startOffsetY > scrollView.contentOffset.y + defaultOffset {
            //下滑
            direction = .down
//            let contentOffset = scrollView.contentOffset
//            let contentSize = scrollView.contentSize
//            if contentOffset.y > 0 && contentOffset.y + scrollView.frame.height < contentSize.height {
//                let delta = contentOffset.y - lastOffset.y
//                if endDragging {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endDragging"), object: true)
//                } else {
//                    if abs(delta) < 5 && scrollView.isTracking == false && scrollView.isDecelerating == true {
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endDragging"), object: true)
//                    } else {
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endDragging"), object: false)
//                    }
//                }
//            }
//            lastOffset = contentOffset
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endDragging"), object: true)
        } else if startOffsetY < scrollView.contentOffset.y - defaultOffset {
            //上滑
            direction = .up
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endDragging"), object: false)
        } else {
            direction = .none
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetY = scrollView.contentOffset.y
        endDragging = false
    }
    
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard direction == .down else { return }
        let isStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if isStop {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endDragging"), object: true)
        }
    }

}
*/

extension WebViewViewModel: WKUIDelegate {
    /*
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let controller = self.currentViewController()
        let alert = UIAlertController(title: "TIPS", message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "OK", style: .default) { action in
            completionHandler()
        }
        alert.addAction(sureAction)
        controller.present(alert, animated: true)
        
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void){
        let controller = self.currentViewController()
        let alert = UIAlertController(title: "TIPS", message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "OK", style: .default) { action in
            completionHandler(true)
        }
        alert.addAction(sureAction)
        controller.present(alert, animated: true)
        
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void){
        let controller = self.currentViewController()
        let alert = UIAlertController(title: "TIPS", message: defaultText, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "OK", style: .default) { action in
            completionHandler(alert.textFields?.first?.text ?? "")
        }
        let sureAction2 = UIAlertAction(title: "CANCEL", style: .default) { action in
            completionHandler(alert.textFields?.first?.text ?? "")
        }
        alert.addAction(sureAction)
        alert.addAction(sureAction2)
        alert.addTextField { textField in
            textField.text = prompt
            textField.placeholder = defaultText
        }
        controller.present(alert, animated: true)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let ismain = navigationAction.targetFrame?.isMainFrame ?? true
        print(ismain)
        if ismain {
            let wk = WKWebView(frame: webView.frame, configuration: configuration)
            wk.uiDelegate = self
            wk.navigationDelegate = self
            wk.load(navigationAction.request)
            
            let vc = UIViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.view = wk
            
            let controller = currentViewController()
            controller.navigationController?.pushViewController(vc, animated: true)
            return wk
            
        }
        return nil
    }*/
}
