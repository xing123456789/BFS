//
//  MyAppView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/4/24.
//

import SwiftUI

struct MyAppView: View {
    
    @ObservedObject var appViewModel = HomeAppViewModel()
    var homeConfig: HomeConfigModel
    
    var body: some View {
        
        HomeContentView(homeConfig: homeConfig, titleString: "我的app", dataSources: appViewModel.apps)
    }
}

