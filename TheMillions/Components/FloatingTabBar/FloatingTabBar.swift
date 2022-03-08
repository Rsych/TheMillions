//
//  FloatingTabBar.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/03/08.
//

import SwiftUI

struct FloatingTabBar: View {
    @Binding var selected: Int
    @State var expand = false
    
    var body: some View {
        HStack {
            Button {
                self.selected = 0
            } label: {
                Image(systemName: "house")
                    .foregroundColor(self.selected == 0 ? .primary : .gray)
                    .padding(.horizontal)
            }
//            Spacer(minLength: 10)
            
            Button {
                self.selected = 1
            } label: {
                Image(systemName: "arrow.left.arrow.right")
                    .foregroundColor(self.selected == 1 ? .primary : .gray)
                    .padding(.horizontal)
            }
            
//            Spacer(minLength: 10)
            
            Button {
                self.selected = 2
            } label: {
                Image(systemName: "rectangle.grid.2x2")
                    .foregroundColor(self.selected == 2 ? .primary : .gray)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
//        .padding(44)
    }
}

struct FloatingTabBar_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTabBar(selected: .constant(0))
    }
}
