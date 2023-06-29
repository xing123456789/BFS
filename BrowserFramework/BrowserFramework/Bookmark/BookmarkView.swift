//
//  BookmarkView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/4/22.
//

import SwiftUI

struct BookmarkView: View {
    
    @ObservedObject var viewModel: BookmarkViewModel
    var homeConfig: HomeConfigModel
    
    var body: some View {
        
        if viewModel.dataSources.count > 0 {
            
            VStack {

                List {
                    ForEach(viewModel.dataSources) {  item in
                        BookmarkCell(linkRecord: item, isLast: false, homeConfig: homeConfig, viewModel: viewModel)
                            .frame(height: 50)
                    }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                .frame(height: CGFloat(viewModel.dataSources.count) * 50)
                .background(RoundedCorners(bl: 6, br: 6))
                .cornerRadius(6)
                .padding(16)
                
                Spacer()
            }
        } else {
            NoResultView(imageName: HistoryConfig(.bookmark).noResultImageName, title: HistoryConfig(.bookmark).noResultTitle)
        }
    }
}

struct RoundedCorners: View {
    
    var color: Color = .white
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    var body: some View {
        
        GeometryReader { proxy in
            Path { path in
                let w = proxy.size.width
                let h = proxy.size.height
                
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }
            .fill(self.color)
        }
    }
}
