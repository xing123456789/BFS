//
//  WebViewController.swift
//  BFS
//
//  Created by ui03 on 2022/8/25.
//

import UIKit
import RxSwift

class WebViewController: UIViewController {

    var fileName: String = ""
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        webView.openWebView(html: "iosqmkkx:/index.html")
        
//        operateMonitor.backMonitor.subscribe(onNext: { [weak self] fileName in
//            guard let strongSelf = self else { return }
//            strongSelf.navigationController?.popViewController(animated: true)
//            operateMonitor.startAnimationMonitor.onNext(fileName)
//        }).disposed(by: disposeBag)
    }
    
    private lazy var webView: CustomWebView = {
        let webView = CustomWebView(frame: CGRect(x: 0, y: 88, width: self.view.bounds.width, height: UIScreen.main.bounds.height - 88), jsNames: ["Photo","DWebViewJS"])
        webView.superVC = self
        return webView
    }()
    
    //用户点击app升级时操作
    private func loadSystemUpdateVersion() {
        self.navigationController?.popViewController(animated: true)
        operateMonitor.startAnimationMonitor.onNext(fileName)
        batchManager.fetchSystemAppNewVersion(fileName: fileName, urlString: "")
    }
}
