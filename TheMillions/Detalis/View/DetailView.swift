//
//  DetailView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/22.
//

import SwiftUI

struct DetailView: View {
    // MARK: - Properties
    @Binding var coin: Coin?
    
    init(coin: Binding<Coin?>) {
        _coin = coin
        print("Itit detail view for \(coin.wrappedValue?.name)")
    }
    // MARK: - Body
    var body: some View {
        Text(coin?.name ?? "")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: .constant(Coin.example))
    }
}
