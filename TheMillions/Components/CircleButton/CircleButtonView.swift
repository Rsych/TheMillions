//
//  CircleButtonView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(.theme.accent)
            .shadow(color: .theme.accent.opacity(0.2), radius: 10, x: 0, y: 0)
            .padding()
            .background(
                .ultraThinMaterial,
                in: Circle()
            )
            .frame(width: 50, height: 50)
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "info")
                .previewLayout(.sizeThatFits)
                .colorScheme(.dark)
            CircleButtonView(iconName: "plus")
                .previewLayout(.sizeThatFits)
        }
        
    }
}
