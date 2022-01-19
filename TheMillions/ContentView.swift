//
//  ContentView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Accent Color")
                    .foregroundColor(.theme.accent)
                Text("Secondary Color")
                    .foregroundColor(.theme.secondaryText)
                Text("red Color")
                    .foregroundColor(.theme.red)
                Text("green Color")
                    .foregroundColor(.theme.green)
            }
            .font(.headline)
        } //: ZStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
