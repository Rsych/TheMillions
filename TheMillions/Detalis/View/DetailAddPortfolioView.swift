//
//  DetailAddPortfolioView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/03/10.
//

import SwiftUI

struct DetailAddPortfolioView: View {
    // MARK: - Properties
    @Binding var coin: Coin?
    init(coin: Binding<Coin?>) {
        _coin = coin
    }
    // MARK: - Body
    var body: some View {
        VStack {
            Text(coin?.currentHoldingValue.currencyTo6Digits() ?? "")
            HStack {
                Text("Current holding is:")
                Text(coin?.currentHoldings?.numberTo6Digits() ?? "0")
            }
        }
    }
}
// MARK: - Preview
struct DetailAddPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAddPortfolioView(coin: .constant(Coin.example))
    }
}
