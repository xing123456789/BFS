//
//  WebViewWrapper.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/6/19.
//

import SwiftUI
import WebKit
import Combine

@dynamicMemberLookup
class WebViewWrapper: ObservableObject, Identifiable, Equatable {
    
    var id = UUID().uuidString
    
    @Published var webView: WKWebView {
        didSet {
            setupObservers()
        }
    }
    
    private var observers: [NSKeyValueObservation] = []
    
    init(id: String = UUID().uuidString) {
        self.id = id
        self.webView = WKWebView()
        
        setupObservers()
    }
    
    private func setupObservers() {
        func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
            return webView.observe(keyPath, options: [.prior]) { _, change in
                
                if change.isPrior {
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                }
            }
        }
        // Setup observers for all KVO compliant properties
        observers = [
            subscriber(for: \.title),
            subscriber(for: \.url),
            subscriber(for: \.estimatedProgress),
            subscriber(for: \.canGoBack),
            subscriber(for: \.canGoForward),
        ]
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<WKWebView, T>) -> T {
        webView[keyPath: keyPath]
    }
    
    static func == (lhs: WebViewWrapper, rhs: WebViewWrapper) -> Bool {
        return lhs.id == rhs.id
    }
}



@dynamicMemberLookup
class ObservableContainer<V> : ObservableObject {
    
    var value: V
    
    init(value: V) {
        self.value = value
    }
    
    subscript<P>(dynamicMember keyPath: WritableKeyPath<V,P>) -> P {
        get {
            value[keyPath: keyPath]
        }
        set {
            objectWillChange.send()
            value[keyPath: keyPath] = newValue
        }
    }
}
