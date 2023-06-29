//
//  HalfSheetPickerView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/5/5.
//

import SwiftUI

struct HalfSheetPickerView: View {
    
    @State var selectedName = ""
    private let imageNames = ["ico_menu_set", "ico_menu_bookmark","ico_menu_history"]
    private let homeImageNames = [ "ico_menu_bookmark","ico_menu_history"]
    @EnvironmentObject var homeViewModel: HomeContentViewModel
    var homeConfig: HomeConfigModel
    
    var body: some View {
        
        VStack {
            Picker("Select image", selection: $selectedName) {
                ForEach(homeConfig.pageType == .webPage ? imageNames : homeImageNames, id: \.self) {
                    Image($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal,16)
            
            if selectedName == "ico_menu_set" {
                MenuView(homeConfig: homeConfig)
                    .environmentObject(homeViewModel)
                    .padding(.vertical, 16)
                Spacer()
            } else if selectedName == "ico_menu_bookmark" {
                BookmarkView(viewModel: BookmarkViewModel(), homeConfig: homeConfig)
            } else if selectedName == "ico_menu_history" {
                SheetHistoryView(viewModel: LinkHistoryViewModel(), type: .linkHistory, homeConfig: homeConfig)
            }
        }
        .background(SwiftUI.Color.init(red: 245.0/255, green: 246.0/255, blue: 247.0/255, opacity: 1))
    }
}

struct HalfSheetPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HalfSheetPickerView(homeConfig: HomeConfigModel())
    }
}
