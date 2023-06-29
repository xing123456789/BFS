//
//  HomeContentViewModel.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/4/28.
//

import SwiftUI

enum PageType {
    case homePage
    case webPage
}

class HomeContentViewModel: ObservableObject, Equatable {
    
    //后续删除
    @Published var linkString = ""
    @Published var hostString = ""
    @Published var linkPlaceHolderString = ""
    @Published var webTitleString = ""
    @Published var pageType: PageType = .homePage
    
    //输入框显示的临时数据
    @Published var tempPlaceholder: String = ""
    @Published var isShowEngine = false      //是否显示搜索引擎视图
    @Published var isShowOverlay: Bool = false      //是否显示覆盖层
    @Published var isPlaceholderObserver: Bool = false      //是否监听placeholder的变化
    @Published var bottom_disabledList = [true,true,false,false,false]
    
    @Published var homeConfigs: [HomeConfigModel] = [HomeConfigModel()]
    
    func saveCurrentConfig(config: HomeConfigModel) {
        
        if homeConfigs.count == 1 {
            homeConfigs = [config]
            return
        }
        
        if let index = homeConfigs.firstIndex(where: { $0.id == config.id}) {
            homeConfigs.remove(at: index)
            homeConfigs.insert(config, at: index)
        }
    }
    
    static func == (lhs: HomeContentViewModel, rhs: HomeContentViewModel) -> Bool {
        return lhs.homeConfigs == rhs.homeConfigs
    }
}

struct HomeConfigModel: Identifiable, Equatable {
    
    var id = UUID().uuidString
    var linkString = ""
    var hostString = ""
    var linkPlaceHolderString = ""
    var webTitleString = ""
    var pageType: PageType = .homePage
    
    static func == (lhs: HomeConfigModel, rhs: HomeConfigModel) -> Bool {
        return lhs.id == rhs.id && lhs.pageType == rhs.pageType && lhs.linkString == rhs.linkString && lhs.hostString == rhs.hostString && lhs.linkPlaceHolderString == rhs.linkPlaceHolderString && lhs.webTitleString == rhs.webTitleString
    }
}


struct HomeBottomModel: Identifiable {
    
    var id = UUID().uuidString
    var isGoback: Bool = false
    var isGoForward: Bool = false
}
