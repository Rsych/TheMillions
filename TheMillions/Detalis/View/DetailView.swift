//
//  DetailView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/22.
//

import SwiftUI

struct DetailView: View {
    // MARK: - Properties
    let coin: Coin
    
    // MARK: - Body
    var body: some View {
        Text(coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: Coin.example)
    }
}
