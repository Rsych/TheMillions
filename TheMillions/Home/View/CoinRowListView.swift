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
    let showHoldingsColumn: Bool
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                leftColumn
                Spacer()
                if showHoldingsColumn {
                    centerColumn
                }
                rightColumn
                    .frame(width: geo.size.width / 3, alignment: .trailing)
                //                .frame(width: UIScreen.main.bounds.width / 3)
            } //: HStack
            .padding(.bottom)
            .font(.subheadline)
        } //: Geo
    }
}
extension CoinRowListView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                
                .font(.headline)
                .padding(.leading, 5)
                .foregroundColor(.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingValue.currencyTo2Digits())
                .bold()
            Text((coin.currentHoldings ?? 0).numberTo6Digits())
        }
        .foregroundColor(.theme.accent)
    }
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.currencyTo2Digits())
                .bold()
            Text(coin.priceChangePercentage24H?.percentToString() ?? "0%")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                        .theme.green : .theme.red
                )
        } //: VStack
    }
}

struct CoinRowListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowListView(coin: Coin.example, showHoldingsColumn: true)
            .preferredColorScheme(.dark)
    }
}
