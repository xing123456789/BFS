//
//  CustomContainerView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/5/10.
//

import SwiftUI

struct CustomContainerView<Content>: View where Content: View {
    
    private let content: Content
    
    private var homeViewModel: HomeContentViewModel
    var config: HomeConfigModel
    
    init(@ViewBuilder content: () -> Content, viewModel: HomeContentViewModel, config: HomeConfigModel) {
        self.content = content()
        self.homeViewModel = viewModel
        self.config = config
    }
    var body: some View {
        content
//            .dismissKeyboard()
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .overlay(searchOverlay, alignment: .topLeading)
    }
    
    @ViewBuilder private var searchOverlay: some View {
        
        if homeViewModel.isShowEngine {
            SearchHolderView(config: config)
                .environmentObject(homeViewModel)
            
        }
    }
}


