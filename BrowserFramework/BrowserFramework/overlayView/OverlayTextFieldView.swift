//
//  OverlayTextFieldView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/5/10.
//

import SwiftUI



struct OverlayTextFieldView: View {
    
    
    @State private var urlString = ""
    @FocusState private var isFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    @State var homeConfig: HomeConfigModel
    
    @EnvironmentObject var homeViewModel: HomeContentViewModel
    
    var body: some View {
        
        HStack {
            
            CustomTextFieldView(content: {
                TextField("搜索或输入网址", text: $homeConfig.linkPlaceHolderString)
                    .frame(height: 40)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 16)
                    .focused($isFocused)
                    .onAppear {
                        isFocused = true
                    }
                    .onTapGesture {
                        homeViewModel.isPlaceholderObserver = true
                    }
            }, config: $homeConfig)
                
            CustomDeleteButton(config: $homeConfig)
                .opacity(homeConfig.linkPlaceHolderString.isEmpty ? 0 : 1)

            Spacer()
        }
        .background(.white)
        .cornerRadius(10)
        
    }
}



