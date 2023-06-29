//
//  GestureAnimationView.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/6/9.
//

import SwiftUI
import Combine

let stopPublisher = PassthroughSubject<Void, Never>()
let startPublisher = PassthroughSubject<Int, Never>()

struct GestureAnimationView<Content: View, T: Identifiable>: View {
    
    
    private var content: (T) -> Content
    private var list: [T]
    private var spacing: CGFloat
    private var trailingSpace: CGFloat
    
    @Binding var index: Int
    @Binding var offset: CGFloat
    @GestureState var gestureOffset: CGFloat = 0
    @State var currentIndex: Int = 0
    @State var totalOffset: Int = 0
    
    init(spacing: CGFloat = 24, trailingSpace: CGFloat = 100, offset: Binding<CGFloat>, index: Binding<Int>, list: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.content = content
        self.list = list
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self._offset = offset
    }
    
    var body: some View {
        GeometryReader { proxy in
            
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                        .offset(y: 0)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + calculateCompleteGestureOffset())
            .gesture(
                DragGesture().updating($gestureOffset, body: { value, out, _ in
                    out = value.translation.width
                })
                .onChanged({ value in
                    let offset = value.translation.width
                    let progress = -offset / width
                    let roundIndex = progress.rounded()
                    //右滑
                    if progress <= 0 {
                        if currentIndex > 0 {
                            self.offset = self.calculateOffset(offset: progress) + CGFloat(totalOffset)
                        }
                    } else {
                        if currentIndex < list.count - 1 {
                            self.offset = self.calculateOffset(offset: progress) + CGFloat(totalOffset)
                        }
                    }
                    index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "stopScroll"), object: "stop")
                })
                .onEnded({ value in
                    let offset = value.translation.width
                    var progress = -offset / width
                    let roundIndex = progress.rounded()
                    currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    withAnimation {
                        if currentIndex == 0 {
                            self.offset = 0
                            self.totalOffset = 0
                        } else if currentIndex == list.count - 1 {
                            self.offset = -CGFloat(currentIndex) * proxy.size.width
                            self.totalOffset = -currentIndex * Int(proxy.size.width)
                        } else {
                            // 向右滑
                            if progress <= 0 {
                                if progress <= -0.5 {
                                    progress = -1.0
                                } else {
                                    progress = 0.0
                                }
                                self.offset = self.calculateOffset(offset: progress) + CGFloat(totalOffset)
                                self.totalOffset += Int(self.calculateOffset(offset: progress))
                            } else {
                                if currentIndex < list.count {
                                    if progress >= 0.5 {
                                        progress = 1.0
                                    } else {
                                        progress = 0.0
                                    }
                                    
                                    self.offset = self.calculateOffset(offset: progress) + CGFloat(totalOffset)
                                    self.totalOffset += Int(self.calculateOffset(offset: progress))
                                }
                            }
                        }
                    }
                    currentIndex = index
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "stopScroll"), object: "start")
                })
            )
            .onReceive(scrollPublisher, perform: { out in
                withAnimation {
                    self.currentIndex = out
                }
                self.offset = -CGFloat(currentIndex) * proxy.size.width
                self.totalOffset = -currentIndex * Int(proxy.size.width)
            })
        }
        .animation(.easeInOut, value: gestureOffset == 0)
    }
    
    private func calculateOffset(offset: CGFloat) -> CGFloat {
        var off = offset
        if off >= 1.0 {
            off = 1.0
        }
        if off <= -1.0 {
            off = -1.0
        }
        return -off * UIScreen.main.bounds.width
    }
    
    private func calculateCompleteGestureOffset() -> CGFloat {
        
        if list.count == 1 {
            if gestureOffset > 0 {
                return min(gestureOffset, 100)
            }
            if gestureOffset < 0 {
                return max(gestureOffset, -100)
            }
        } else {
            if currentIndex == 0 {
                if gestureOffset > 0 {
                    return min(gestureOffset, 100)
                }
            }
            if currentIndex == list.count - 1 {
                if gestureOffset < 0 {
                    return max(gestureOffset, -100)
                }
            }
        }
        
        return gestureOffset
    }
    
    private func getIndex(item: T) -> Int {
        let index = list.firstIndex(where: { $0.id == item.id }) ?? 0
        return index
    }
}


