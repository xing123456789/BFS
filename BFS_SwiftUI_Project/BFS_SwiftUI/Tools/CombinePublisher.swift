//
//  CombinePublisher.swift
//  BFS_SwiftUI
//
//  Created by ui03 on 2023/6/20.
//

import Foundation
import Combine

let homeDataPublisher = PassthroughSubject<[[String:String]], Never>()
let addPublisher = PassthroughSubject<Void, Never>()
let scrollPublisher = PassthroughSubject<Int, Never>()
