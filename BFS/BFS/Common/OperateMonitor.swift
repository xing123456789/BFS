//
//  OperateMonitor.swift
//  BFS
//
//  Created by ui03 on 2022/9/5.
//

import Foundation
import RxSwift

let operateMonitor = OperateMonitor()
class OperateMonitor {
    
    let refreshCompleteMonitor = PublishSubject<String>()
    let startAnimationMonitor = PublishSubject<String>()
    let backMonitor = PublishSubject<String>()
}
