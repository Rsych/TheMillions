//
//  LaunchView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/24.
//

import SwiftUI

struct LaunchView: View {
    // MARK: - Properties
    @State private var loadingText: [String] = "Loading The Millions, Not a portfolio manager".map { String($0) }
    @State private var showLoadingText = false
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    
    @Binding var showLaunchView: Bool
    
    private let timer = Timer.publish(every: 0.06, on: .main, in: .common).autoconnect()
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.theme.logoColor
                .ignoresSafeArea()
            Image("logo")
            //                .resizable()
            //                .frame(width: 100, height: 100)
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(.theme.accent)
                                .offset(y: counter == index ? -5 : 0)
                        } //: Loop
                    } //: HStack
                    //                    .transition(.scale.animation(.easeIn))
                }
            }
            .offset(y: 60)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 1 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
