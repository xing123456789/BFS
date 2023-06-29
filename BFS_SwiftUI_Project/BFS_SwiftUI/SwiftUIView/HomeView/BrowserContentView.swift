//
//  BrowserContentView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/6/20.
//

import SwiftUI

struct BrowserContentView: View {
    
    @ObservedObject var appViewModel = HomeAppViewModel()
    @StateObject private var homeViewModel = HomeContentViewModel()
    
    @State var homeOffset: CGFloat = 0
    @State private var isShowSheet: Bool = false
    @State var currentIndex: Int = 0
    
    var body: some View {
        
        VStack {
            Spacer()
            if appViewModel.apps.count > 0 {
                CustomContainerView(content: {
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(homeViewModel.homeConfigs, id: \.id) { config in
                                HomePageView(isShowSheet: $isShowSheet, homeConfig: config)
                                    .frame(width: UIScreen.main.bounds.width)
                                    .environmentObject(homeViewModel)
                                    
                            }
                        }
                        .offset(x: homeOffset)
                    }
                    .scrollDisabled(true)
                }, viewModel: homeViewModel, config: homeViewModel.homeConfigs[currentIndex])
            } else {
                emptyView()
                Spacer()
            }
            
            GestureAnimationView(offset: $homeOffset, index: $currentIndex, list: homeViewModel.homeConfigs) { config in
                if homeViewModel.homeConfigs.count == 1 {
                    BrowserAddressBarView(homeConfig: config)
                        .frame(width: UIScreen.main.bounds.width - 48)
                        .padding(.leading,36)
                } else {
                    BrowserAddressBarView(homeConfig: config)
                }
            }
            .frame(height: 45)
            .background(.clear)
            
            HomeBottomView(isShowSheet: $isShowSheet, webViewModel: WebViewViewModel(), homeConfig: homeViewModel.homeConfigs[currentIndex])
                .edgesIgnoringSafeArea(.bottom)
                
        }
        .onReceive(addPublisher, perform: { out in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopScroll"), object: "stop")
            homeViewModel.homeConfigs.append(HomeConfigModel())
            currentIndex = homeViewModel.homeConfigs.count - 1
            scrollPublisher.send(homeViewModel.homeConfigs.count - 1)
            withAnimation {
                self.homeOffset = -UIScreen.main.bounds.width * CGFloat(homeViewModel.homeConfigs.count - 1)
            }
        })
        .environmentObject(homeViewModel)
        .background(SwiftUI.Color.init(red: 245.0/255, green: 246.0/255, blue: 247.0/255, opacity: 1))
        .overlay(starOverlay, alignment: .topLeading)
    }
    
    @ViewBuilder
    func emptyView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Image("empty_browser")
                .padding(.horizontal, 80)
                    
            Text("DwebBrowser")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hexString: "0A1626"))
        }
    }
    
    @ViewBuilder private var starOverlay: some View {
        
        if homeViewModel.isShowOverlay {
            OverlayView(config: homeViewModel.homeConfigs[currentIndex])
                .environmentObject(homeViewModel)
                .background(.white)
        }
    }
}

struct BrowserContentView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserContentView()
    }
}
