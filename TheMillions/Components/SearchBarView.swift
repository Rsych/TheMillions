//
//  SearchBarView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/20.
//

import SwiftUI

struct SearchBarView: View {
    // MARK: - Properties
    @Binding var searchText: String
    // MARK: - Body
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? .theme.secondaryText : .theme.accent)
            
            TextField("Search by name or symbol…", text: $searchText)
                .foregroundColor(.theme.accent)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
//                        .background(Color.red) // check area if ok
                        .foregroundColor(.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }, alignment: .trailing)
        } //: HStack
        .font(.headline)
        .padding()
        .background(RoundedRectangle(cornerRadius: 25)
                        .fill(Color.theme.background)
                        .shadow(color: .theme.accent.opacity(0.15), radius: 10, x: 0, y: 0))
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant("s"))
                .preferredColorScheme(.dark)
            SearchBarView(searchText: .constant("d"))
                .preferredColorScheme(.light)
        }
        .previewLayout(.sizeThatFits)
    }
}
