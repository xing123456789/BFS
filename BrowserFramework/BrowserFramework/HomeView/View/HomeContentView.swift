//
//  HomeContentView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/4/24.
//

import SwiftUI

struct HomeContentView: View {
    
    //视图左右间距20，列间距10 每列显示4个，
    private let imgWidth = (UIScreen.main.bounds.width - 70) * 0.25 * 0.78 - 3
    @State var homeConfig: HomeConfigModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var titleString: String
    var dataSources: [WebModel]
    
    @EnvironmentObject var homeViewModel: HomeContentViewModel
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(titleString)
                .font(.system(size: 20, weight: .bold))
                .frame(height: 40)
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(dataSources) { website in
                    Button {
                        NotificationCenter.default.post(name: NSNotification.Name.OpenApp, object: website.link)
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } label: {
                        VStack {
                            Image(uiImage: UIImage.bundleImage(name: website.icon))
                                .resizable()
                                .frame(width: imgWidth,height: imgWidth)
                                .cornerRadius(12.0)
                            
                            Text(website.title)
                                .font(.system(size: 13.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                        }
                    }
                }
            }
            
        })
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))

    }
}

struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeContentView(homeConfig: HomeConfigModel(), titleString: "", dataSources: [])
    }
}
