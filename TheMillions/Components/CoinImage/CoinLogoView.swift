//
//  CoinLogoView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/21.
//

import SwiftUI

struct CoinLogoView: View {
    // MARK: - Properties
    let coin: Coin
    // MARK: - Body
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinLogoView(coin: Coin.example)
                .padding()
                .previewLayout(.sizeThatFits)
            CoinLogoView(coin: Coin.example)
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
