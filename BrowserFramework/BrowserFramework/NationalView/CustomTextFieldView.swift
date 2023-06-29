//
//  CustomTextFieldView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/5/10.
//

import SwiftUI
import Combine

struct CustomTextFieldView<Content>: View where Content: View {
    
    private let content: Content
    @Binding var homeConfig: HomeConfigModel
    
    @EnvironmentObject var homeViewModel: HomeContentViewModel
    
    init(@ViewBuilder content: () -> Content, config: Binding<HomeConfigModel>) {
        self.content = content()
        self._homeConfig = config
    }
    
    var body: some View {
        content
            .foregroundColor(.black)
            .accentColor(SwiftUI.Color.init(white: 138 / 255))
            .keyboardType(.URL)
            .onSubmit {
                self.textFieldSubmitAction()
            }
            .onChange(of: homeConfig.linkPlaceHolderString) { newValue in
                homeViewModel.tempPlaceholder = newValue
                if homeViewModel.isPlaceholderObserver {
                    homeViewModel.isShowEngine = !newValue.isEmpty
                    SearchEngineViewModel.shared.fetchRecordList(placeHolder: newValue)
                }
            }
    }
    
    //点击输入框return按钮
    private func textFieldSubmitAction() {
        homeViewModel.isShowEngine = false
        homeViewModel.isShowOverlay = false
        homeViewModel.tempPlaceholder = ""
        homeConfig.pageType = .webPage
        let isLink = isLink(urlString: homeConfig.linkPlaceHolderString)
        if isLink {
            homeConfig.linkString = handleURLPrefix(urlString: homeConfig.linkPlaceHolderString)
        } else {
            homeConfig.linkString = searchContent(for: .baidu, text: paramURLAbsoluteString(with: homeConfig.linkPlaceHolderString))
        }
        homeConfig.hostString = fetchURLHost(urlString: homeConfig.linkString)
        homeViewModel.saveCurrentConfig(config: homeConfig)
        NotificationCenter.default.post(name: Notification.Name.loadUrl, object: homeConfig)
    }
}

