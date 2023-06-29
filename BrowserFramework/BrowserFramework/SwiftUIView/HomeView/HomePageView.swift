//
//  SrollContentDataView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/6/8.
//

import SwiftUI
import WebKit

struct HomePageView: View {
    
//    var homeViewModel: HomeContentViewModel
    @Binding var isShowSheet: Bool
    @State var homeConfig: HomeConfigModel
    
    @EnvironmentObject var homeViewModel: HomeContentViewModel
    
    var body: some View {
        
        if homeConfig.pageType == .homePage {
            CustomContainerView(content: {
                ScrollView {
                    MyAppView(homeConfig: homeConfig)
                }
            }, viewModel: homeViewModel, config: homeConfig)
            .onAppear {
                addWebViewObserver()
            }
        } else {
            if homeConfig.pageType == .webPage {
                
                MAUIWebView(id: homeConfig.id, urlString: homeConfig.linkString)
                    .onAppear {
                        self.isShowSheet = false
                        addWebViewObserver()
                    }
            }
        }
    }
    
    private func addWebViewObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name.loadUrl, object: nil, queue: nil) { noti in
            guard let obj = noti.object as? HomeConfigModel else { return }
            guard homeConfig.id == obj.id else { return }
            self.isShowSheet = false
            homeConfig = obj
        }
        NotificationCenter.default.addObserver(forName: Notification.Name.webViewTitle, object: nil, queue: nil) { notification in
            let id = notification.userInfo?["id"] as? String ?? ""
            let title = notification.userInfo?["title"] as? String ?? ""
            guard homeConfig.id == id else { return }
            homeConfig.webTitleString = title
            homeViewModel.saveCurrentConfig(config: homeConfig)
        }
        NotificationCenter.default.addObserver(forName: Notification.Name.hiddenBottomView, object: nil, queue: nil) { _ in
            self.isShowSheet = false
        }
    }
}


