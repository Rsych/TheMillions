//
//  CoinRowListView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import SwiftUI

struct CoinRowListView: View {
    // MARK: - Properties
    let coin: Coin
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30, height: 30)
            Text(coin.symbol)
                .font(.headline)
                .padding(.leading, 5)
                .foregroundColor(.theme.accent)
            Spacer()
            VStack {
                Text("\(coin.currentPrice)")
                    .bold()
                Text("\(coin.priceChangePercentage24H ?? 0)%")
                    .foregroundColor(
                        (coin.priceChangePercentage24H ?? 0) >= 0 ?
                            .theme.green : .theme.red
                    )
            }
        }
    }
}

struct CoinRowListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowListView(coin: Coin.example)
    }
}
