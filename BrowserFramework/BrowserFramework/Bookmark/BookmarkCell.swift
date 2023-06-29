//
//  BookmarkCell.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/5/29.
//

import SwiftUI

struct BookmarkCell: View {
    
    var linkRecord: LinkRecord
    var isLast: Bool
    @State var homeConfig: HomeConfigModel
    
    @ObservedObject var viewModel: HistoryViewModel
    
    @EnvironmentObject var homeViewModel: HomeContentViewModel
    
    var body: some View {
        Button {
            if homeConfig.pageType == .webPage {
                if homeConfig.linkString == linkRecord.link {
                    NotificationCenter.default.post(name: Notification.Name.hiddenBottomView, object: nil)
                    return
                }
            } else {
                homeConfig.pageType = .webPage
            }
            homeConfig.linkString = linkRecord.link
            homeConfig.hostString = fetchURLHost(urlString: linkRecord.link)
            homeViewModel.saveCurrentConfig(config: homeConfig)
            NotificationCenter.default.post(name: Notification.Name.loadUrl, object: homeConfig)
        } label: {
            VStack(alignment: .leading, content: {
                
                HStack(alignment: .center, spacing: 12) {
//                    Image(linkRecord.imageName)
                    Image(uiImage: UIImage.bundleImage(name: linkRecord.imageName))
                        .frame(width: 28, height: 28)
                        .background(.blue)
                        .padding(.leading, 12)
                        .padding(.top, 11)
                    
                    Text(linkRecord.title)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hexString: "0A1626"))
                        .frame(height: 20)
                        .padding(.top, 15)
                        .lineLimit(1)
                }
                
                Spacer()
                
                if !isLast {
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color(hexString: "E8EBED"))
                        .padding(.bottom, 1)
                        .padding(.leading, 52)
                }
            })
            .background(.clear)
        }
        .onAppear {
            guard isLast else { return }
            viewModel.loadMoreHistoryData()
        }
    }
}

