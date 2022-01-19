//
//  TheMillionsApp.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import SwiftUI

@main
struct TheMillionsApp: App {
    @StateObject private var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
