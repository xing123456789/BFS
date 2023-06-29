//
//  DownloadAppView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/5/25.
//

import SwiftUI

struct DownloadAppView: View {
    
    private let images: [String] = ["post3","post3","post3"]
    @State var offset: CGPoint = .zero
    @ObservedObject var viewModel = DownloadImageViewModel()
    
    @State private var content: String = "获取"
    @State private var btn_width: CGFloat = 80
    @State private var backColor: SwiftUI.Color = SwiftUI.Color.blue
    @State private var isRotate = false
    @State private var isWaiting = false
    @State private var progress: CGFloat = 0.0
    @State private var defaultApp: APPModel?
    @State private var isPresented = false
    @State private var currentImageIndex: Int = 0
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            CustomUIScrollView(content: {
                VStack(spacing: 0) {
                    
//                    HeaderView()
                    
                    AppTitleView()
                    
                    Divider().frame(height: 0.5).background(.white.opacity(0.35))
                        .padding(.bottom, 20)
                        .padding(.horizontal,16)
                    
                    AppHistoryDataView()
                    
                    Divider().frame(height: 0.5).background(.white.opacity(0.35))
                        .padding(.vertical, 20)
                        .padding(.horizontal,16)
                    
                    AppImagesView()
                    
                    Divider().frame(height: 0.5).background(.white.opacity(0.35))
                        .padding(.vertical, 20)
                        .padding(.horizontal,16)
                    
                    AppIntroductionView()
                    
                    Divider().frame(height: 0.5).background(.white.opacity(0.35))
                        .padding(.vertical, 20)
                        .padding(.horizontal,16)
                    
                    InfoDataView()
                    
                }
            }, offset: $offset, showIndication: false, axis: .vertical)
           
            navigationView()
                .frame(maxWidth: .infinity)
                .padding(.top)
                .background(SwiftUI.Color.white.opacity(calculateNavigationViewAlpha()))
        }
        .preferredColorScheme(.light)
        .onReceive(downloadPublisher) { out in
            progress = CGFloat(out)
        }
        .onAppear {
            loadAppInfo()
        }
        .sheet(isPresented: $isPresented) {
            presentImageController(index: currentImageIndex)
        }
    }
    
    @ViewBuilder
    func navigationView() -> some View {
        
        ZStack(alignment: .center) {
            HStack(alignment: .center) {
                Spacer()
                
                DownloadButtonView(urlString: defaultApp?.bundle_url ?? "", content: $content, btn_width: $btn_width, backColor: $backColor, isRotate: $isRotate, isWaiting: $isWaiting, progress: $progress)
                    .padding(.trailing, 20)
                    .padding(.bottom, 5)
            }
            Image(uiImage: viewModel.iconImage ?? UIImage(named: "360")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
//                .background(.white)
                .cornerRadius(20)
                .padding(.bottom,10)
        }
        .opacity(calculateNavigationViewSubViewAlpha())
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = size.height + minY
            
            Image("post2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: height > 0 ? height : 0, alignment: .top)
                .cornerRadius(15)
                .offset(y: -minY)
        }
        .frame(height: 200)
    }
    
    @ViewBuilder
    func AppTitleView() -> some View {
        HStack(alignment: .top) {
            Image(uiImage: viewModel.iconImage ?? UIImage(named: "360")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                .background(.white)
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(defaultApp?.name ?? "")
                    .font(.system(size: 20,weight: .bold))
                Spacer()
                DownloadButtonView(urlString: defaultApp?.bundle_url ?? "", content: $content, btn_width: $btn_width, backColor: $backColor, isRotate: $isRotate, isWaiting: $isWaiting, progress: $progress)
            }
            .padding(.leading,10)
            
            Spacer()
        }
        .padding(.horizontal,20)
        .padding(.vertical,20)
    }
    
    @ViewBuilder
    func AppImagesView() -> some View {
        
        VStack {
            Text("预览")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.images.indices, id: \.self) { index in
                        let image = viewModel.images[index]
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 220, height: 350)
                            .cornerRadius(20)
                            .onTapGesture {
                                self.currentImageIndex = index
                                self.isPresented.toggle()
                            }
                    }
                }
            }
            .padding(.horizontal,10)
        }
    }
    
    @ViewBuilder
    func presentImageController(index: Int) -> some View {
        
        GeometryReader { geometry in
            VStack(alignment: .trailing) {
                Button {
                    self.isPresented = false
                } label: {
                    Text("完成")
                }
                .padding(.trailing, 20)
                .padding(.top, 20)

                Spacer()
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.images.indices, id: \.self) { index in
                                let image = viewModel.images[index]
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: geometry.size.width - 30)
                                    .cornerRadius(20)
                            }
                        }
                        .onAppear {
                            proxy.scrollTo(currentImageIndex)
                        }
                    }
                    .padding(.horizontal,10)
                }
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func AppHistoryDataView() -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("新功能")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("版本 \(defaultApp?.version ?? "")")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
            
            ForEach(defaultApp?.new_feature ?? [], id: \.self) { content in
                Text("- \(content)")
            }
        }
        .padding(.leading,20)
    }
    
    @ViewBuilder
    func AppIntroductionView() -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("简介")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
            Text(defaultApp?.description ?? "")
        }
        .padding(.leading,20)
    }
    
    @ViewBuilder
    func InfoDataView() -> some View {
        
        let titles = ["销售商","大小"]
        let contents = [defaultApp?.author?.joined(separator: ", ") ?? "", calculateAppSize()]
        VStack(alignment: .leading, spacing: 10) {
            
            Text("信息")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
            
            ForEach(0..<titles.count, id: \.self) { index in
                
                HStack {
                    Text(titles[index])
                    Spacer()
                    Text(contents[index])
                }
                .padding(.vertical,10)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func calculateNavigationViewAlpha() -> CGFloat {
        
        if offset.y <= 0 {
            return 0.0
        }
        if offset.y >= 60 {
            return 1.0
        }
        return offset.y / 60
    }
    
    
    private func calculateNavigationViewSubViewAlpha() -> CGFloat {
        
        if offset.y >= 60 {
            return 1.0
        }
        return 0
    }
    
    private func calculateAppSize() -> String {
        
        guard defaultApp != nil else { return "" }
        
        if defaultApp!.bundle_size > 1024 * 1024 {
            return String(format: "%.2f MB", CGFloat(defaultApp!.bundle_size) / (1024.0 * 1024.0))
        }
        if defaultApp!.bundle_size > 1024 {
            return String(format: "%.2f KB", CGFloat(defaultApp!.bundle_size) / 1024.0)
        }
        return "\(defaultApp!.bundle_size)B"
    }
    
    private func loadAppInfo() {
        
        guard let url = URL(string: "https://dweb.waterbang.top/metadata.json") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if data != nil {
                DispatchQueue.main.async {
                    let str = String(data: data!, encoding: .utf8)
                    guard let dict = ChangeTools.stringValueDic(str ?? "") else {
                        return
                    }
//                    self.defaultApp = APPModel(dict: dict)
//                    self.viewModel.loadIcon(urlString: self.defaultApp?.icon ?? "", placeHoldImage: UIImage(named: "360")!)
//                    self.viewModel.loadImages(imageNames: self.defaultApp?.images ?? [], placeHoldImage: UIImage(named: "post3")!)
                }
            }
        }
        task.resume()
    }
}

struct DownloadAppView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadAppView()
    }
}

struct APPModel: Identifiable, Codable {
    

    var id: String
    var server: [String: String]
    var dweb_deeplinks: [String]
    var icon: String
    var name: String
    var short_name: String
    var description: String
    var images: [String]?
    var bundle_url: String
    var author: [String]?
    var version: String
    var categories: [String]?
    var new_feature: [String]?
    var bundle_size: Int
    var home: String
    var bundle_hash: String
    var plugins: [String]?
    var release_date: String
    var permissions: [String]?
    
    init(id: String, server: [String : String], dweb_deeplinks: [String], icon: String, name: String, short_name: String, description: String, images: [String]? = nil, bundle_url: String, author: [String]? = nil, version: String, categories: [String]? = nil, new_feature: [String]? = nil, bundle_size: Int, home: String, bundle_hash: String, plugins: [String]? = nil, release_date: String, permissions: [String]? = nil) {
        self.id = id
        self.server = server
        self.dweb_deeplinks = dweb_deeplinks
        self.icon = icon
        self.name = name
        self.short_name = short_name
        self.description = description
        self.images = images
        self.bundle_url = bundle_url
        self.author = author
        self.version = version
        self.categories = categories
        self.new_feature = new_feature
        self.bundle_size = bundle_size
        self.home = home
        self.bundle_hash = bundle_hash
        self.plugins = plugins
        self.release_date = release_date
        self.permissions = permissions
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case server
        case dweb_deeplinks
        case icon
        case name
        case short_name
        case description
        case images
        case bundle_url
        case author
        case version
        case categories
        case new_feature
        case bundle_size
        case home
        case bundle_hash
        case plugins
        case release_date
        case permissions
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(server, forKey: .server)
        try container.encode(dweb_deeplinks, forKey: .dweb_deeplinks)
        try container.encode(icon, forKey: .icon)
        try container.encode(name, forKey: .name)
        try container.encode(short_name, forKey: .short_name)
        try container.encode(description, forKey: .description)
        try container.encode(images, forKey: .images)
        try container.encode(bundle_url, forKey: .bundle_url)
        try container.encode(author, forKey: .author)
        try container.encode(version, forKey: .version)
        try container.encode(categories, forKey: .categories)
        try container.encode(new_feature, forKey: .new_feature)
        try container.encode(bundle_size, forKey: .bundle_size)
        try container.encode(home, forKey: .home)
        try container.encode(bundle_hash, forKey: .bundle_hash)
        try container.encode(plugins, forKey: .plugins)
        try container.encode(release_date, forKey: .release_date)
        try container.encode(permissions, forKey: .permissions)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try? container.decode(String.self, forKey: .id)
        let server = try? container.decode([String:String].self, forKey: .server)
        let dweb_deeplinks = try? container.decode([String].self, forKey: .dweb_deeplinks)
        let icon = try? container.decode(String.self, forKey: .icon)
        let name = try? container.decode(String.self, forKey: .name)
        let short_name = try? container.decode(String.self, forKey: .short_name)
        let description = try? container.decode(String.self, forKey: .description)
        let images = try? container.decode([String].self, forKey: .images)
        let bundle_url = try? container.decode(String.self, forKey: .bundle_url)
        let author = try? container.decode([String].self, forKey: .author)
        let version = try? container.decode(String.self, forKey: .version)
        let categories = try? container.decode([String].self, forKey: .categories)
        let new_feature = try? container.decode([String].self, forKey: .new_feature)
        let bundle_size = try? container.decode(Int.self, forKey: .bundle_size)
        let home = try? container.decode(String.self, forKey: .home)
        let bundle_hash = try? container.decode(String.self, forKey: .bundle_hash)
        let plugins = try? container.decode([String].self, forKey: .plugins)
        let release_date = try? container.decode(String.self, forKey: .release_date)
        let permissions = try? container.decode([String].self, forKey: .permissions)
        self.init(id: id ?? "", server: server ?? [:], dweb_deeplinks: dweb_deeplinks ?? [], icon: icon ?? "", name: name ?? "", short_name: short_name ?? "", description: description ?? "", images: images, bundle_url: bundle_url ?? "", author: author, version: version ?? "", categories: categories, new_feature: new_feature, bundle_size: bundle_size ?? 0, home: home ?? "", bundle_hash: bundle_hash ?? "", plugins: plugins, release_date: release_date ?? "", permissions: permissions)
    }
}

