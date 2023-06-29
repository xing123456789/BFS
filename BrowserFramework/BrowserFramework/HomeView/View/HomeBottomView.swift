//
//  HomeBottomView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/4/24.
//

import SwiftUI
import Combine

struct HomeBottomView: View {
    
    private let imageNames: [String] = ["ico_bottomtab_left", "ico_bottomtab_right", "jiahao", "morePage", "ico_bottomtab_more"]
    
    @Binding var isShowSheet: Bool
    @State var webViewModel: WebViewViewModel = WebViewViewModel()
    var homeConfig: HomeConfigModel
    @EnvironmentObject var homeViewModel: HomeContentViewModel
    
    var body: some View {
        HStack {
            
            Spacer()
            
            ForEach(0..<imageNames.count, id: \.self) { index in

                Spacer()
                Button {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    switch index {
                    case 0:
                        webViewModel.goBack()
                    case 1:
                        webViewModel.goForward()
                    case 2:
                        print("click add")
                        addPublisher.send(())
                    case 3:
                        print("more page")
                    case 4:
                        isShowSheet.toggle()
                    default:
                        break
                    }
                } label: {

                    Image(uiImage: UIImage.bundleImage(name: imageNames[index] + (homeViewModel.bottom_disabledList[index] ? "_disabled" : "_normal")))
//                    Image(imageNames[index] + (homeViewModel.bottom_disabledList[index] ? "_disabled" : "_normal"))
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .disabled(homeViewModel.bottom_disabledList[index])
                .halfSheet(showSheet: $isShowSheet) {
                    ZStack {
                        SwiftUI.Color.white
                        HalfSheetPickerView(selectedName: homeConfig.pageType == .webPage ? "ico_menu_set" : "ico_menu_bookmark", homeConfig: homeConfig)
                            .environmentObject(homeViewModel)
                    }
                    .padding(.top, 28)
                    .background(.white)
                    .cornerRadius(10)
                } onEnd: {
                    
                }

                Spacer()
            }
            Spacer()
        }
        .background(SwiftUI.Color.init(red: 245.0/255, green: 246.0/255, blue: 247.0/255, opacity: 1))
        .onAppear {
            NotificationCenter.default.addObserver(forName: Notification.Name.goBack, object: nil, queue: nil) { notification in
                let goBack = notification.userInfo?["goBack"] as? Bool ?? false
                homeViewModel.bottom_disabledList[0] = !goBack
            }
            
            NotificationCenter.default.addObserver(forName: Notification.Name.goForward, object: nil, queue: nil) { notification in
                let goForward = notification.userInfo?["goForward"] as? Bool ?? false
                homeViewModel.bottom_disabledList[1] = !goForward
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
}


