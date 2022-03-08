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
    @StateObject var appLockVM = AppLockViewModel()
    @StateObject var dataController: DataController
    @Environment(\.scenePhase) var scenePhase
    @State var blurRadius: CGFloat = 0
    
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                        .environmentObject(vm)
                        .environmentObject(appLockVM)
                        .environmentObject(dataController)
                } //: NavView
                .navigationViewStyle(.stack)
                // enable it later before production
//                ZStack {
//                    if showLaunchView {
//                        LaunchView(showLaunchView: $showLaunchView)
//                            .transition(.move(edge: .leading))
//                    }
//                } //: ZStack
//                // to fix ZStack display error
//                .zIndex(2.0)
            }
            
            .blur(radius: blurRadius)
            .onChange(of: scenePhase, perform: { value in
                switch value {
                case .active :
                    blurRadius = 0
                case .background:
                    appLockVM.isAppUnLocked = false
                case .inactive:
                    blurRadius = 5
                @unknown default:
                    print("unknown")
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                vm.appReloaded()
            }
        }
    }
}
