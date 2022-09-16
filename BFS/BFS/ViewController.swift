//
//  ViewController.swift
//  BFS
//
//  Created by ui03 on 2022/8/25.
//

import UIKit
import Alamofire
import RxSwift

class ViewController: UIViewController {

    var button: UIButton!
    var label: UILabel!
    var redlabel: UILabel!
    
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer = CAShapeLayer()
    
    
    var appNames: [String] = []
    var buttons: [UIButton] = []
    var labels: [UILabel] = []
    
    
    var imageV3: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        batchManager.initBatchFile()
        
        appNames = batchManager.appFilePaths
        
        for i in stride(from: 0, to: appNames.count, by: 1) {
            let name = appNames[i]
            let button = UIButton(frame: CGRect(x: 100 + i * 90, y: 200, width: 60, height: 60))
            button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
            button.setImage(batchManager.currentAppImage(fileName: name), for: .normal)
            button.tag = i
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            self.view.addSubview(button)
            buttons.append(button)
            
            let label = UILabel(frame: CGRect(x: button.frame.minX, y: 280, width: 60, height: 20))
            label.textAlignment = .center
            label.textColor = .black
            label.text = batchManager.currentAppName(fileName: name)
            self.view.addSubview(label)
            labels.append(label)
        }
        
        imageV3 =  UIImageView(frame: CGRect(x: 175, y: 375, width: 80, height: 80))
        imageV3.image = UIImage(named: "carbon_stamp")
        imageV3.layer.cornerRadius = 10
        imageV3.layer.masksToBounds = true
        self.view.addSubview(imageV3)
        
        redlabel = UILabel(frame: CGRect(x: 245, y: 375, width: 10, height: 10))
        redlabel.backgroundColor = .red
        redlabel.layer.cornerRadius = 5
        redlabel.layer.masksToBounds = true
        redlabel.isHidden = true
        self.view.addSubview(redlabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(update(noti:)), name: NSNotification.Name.progressNotification, object: nil)
        
        operateMonitor.startAnimationMonitor.subscribe(onNext: { [weak self] fileName in
            guard let strongSelf = self else { return }
            if let index = strongSelf.appNames.firstIndex(of: fileName) {
                let button = strongSelf.buttons[index]
                button.setupForAppleReveal()
            }
//            strongSelf.imageV3.setupForAppleReveal(tag: strongSelf.appTag(name: fileName))
        }).disposed(by: disposeBag)
    }
    
    @objc func update(noti: Notification) {
        guard let infoDict = noti.userInfo else { return }
        guard let type = infoDict["progress"] as? String else { return }
        let fileName = infoDict["fileName"] as? String
//        guard let type = infoDict["progress"] as? String, type == "complete" else { return }
//        customFileManager.updateFileType()
        DispatchQueue.main.async {
            if type == "complete" {
                if fileName != nil {
                    batchManager.updateFileType(fileName: fileName!)
                    self.redlabel.isHidden = false
                    if let index = self.appNames.firstIndex(of: fileName!) {
                        let button = self.buttons[index]
                        button.setImage(batchManager.currentAppImage(fileName: fileName!), for: .normal)
//
//                        let label = self.labels[index]
//                        label.text = batchManager.currentAppName(fileName: fileName!)
//                        self.redlabel.isHidden = false

                        button.startExpandAnimation()
                    }
                }
            }
        }
        
        if Double(type) != nil {
            
         //   shapeLayer.strokeEnd = Double(type)!
            
            var count = Double(type)!
            if count >= 0.98 {
                count = 0.98
            }
            if let index = self.appNames.firstIndex(of: fileName!) {
                let button = self.buttons[index]
                button.startProgressAnimation(progress: 1.0 - count)
            }
//            imageV3.startProgressAnimation(progress: 1.0 - count)
        }
        
    }
    
    @objc func tap(sender: UIButton) {
        
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.toValue = 1
//        animation.duration = 2.5
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        shapeLayer.add(animation, forKey: "stokeAnimation")
        
        
        guard sender.tag < appNames.count else { return }
        let name = appNames[sender.tag]
        let type = batchManager.currentAppType(fileName: name)
        if type == .system {
            let second = WebViewController()
            second.fileName = name
            self.navigationController?.pushViewController(second, animated: true)
        } else if type == .recommend {
            batchManager.clickRecommendAppAction(fileName: name)
        }
    }
}

