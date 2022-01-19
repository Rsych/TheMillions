//
//  CircleButtonAnimationView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animation: Bool
    
    var body: some View {
        
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animation ? 1.0 : 0.0)
            .opacity(animation ? 0.0 : 1.0)
            .animation(animation ? .easeOut(duration: 1.0) : .none)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animation: .constant(true))
            .frame(width: 100, height: 100)
            .foregroundColor(.red)
    }
}
