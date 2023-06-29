//
//  HomeAppViewModel.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/6/20.
//

import SwiftUI

class HomeAppViewModel : ObservableObject {
    
    @Published var apps: [WebModel] = []
      
      init() {
          apps = [WebModel(icon: "douyu", title: "碳元域", link: "http://www.baidu.com")]
          //从app列表数据库中取
//          _ = homeDataPublisher.sink(receiveValue: { [weak self] list in
//              guard let strongSelf = self, list.count > 0 else { return }
//              var appList: [WebModel] = []
//              for dict in list {
//                  var model = WebModel(icon: dict["icon"] ?? "", title: dict["title"] ?? "", link: dict["link"] ?? "")
//                  appList.append(model)
//              }
//              strongSelf.apps = appList
//          })
      }
}



