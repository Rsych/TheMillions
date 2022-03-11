//
//  DetailAddPortfolioView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/03/10.
//

import SwiftUI

struct DetailAddPortfolioView: View {
    // MARK: - Properties
    @Binding var showAddToPortfolio: Bool
    @Binding var coin: Coin?
    init(coin: Binding<Coin?>, showAddToPortfolio: Binding<Bool>) {
        _coin = coin
        _showAddToPortfolio = showAddToPortfolio
    }
    // MARK: - Body
    var body: some View {
        VStack {
            Text(coin?.currentHoldingValue.currencyTo6Digits() ?? "")
            Spacer()
            HStack {
                Text("Current holding is:")
                Text(coin?.currentHoldings?.numberTo6Digits() ?? "0")
            }
            Spacer()
            
            Button {
                showAddToPortfolio = false
            } label: {
                Text("Done")
                    .frame(maxWidth:.infinity)
                    .padding()
                    .accentColor(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 14.0, style: .continuous))
            } //: Button
            .frame(maxWidth: 200.0)
            .padding()
            .offset(y: UIScreen.main.bounds.height / 8)
        }
        .frame(height: UIScreen.main.bounds.height / 2)
    }
}
// MARK: - Preview
struct DetailAddPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAddPortfolioView(coin: .constant(Coin.example), showAddToPortfolio: .constant(true))
    }
}
