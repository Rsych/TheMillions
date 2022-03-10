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
        print("Itit detail loading view for \(coin.wrappedValue?.name)")
    }
    // MARK: - Body
    var body: some View {
        Text(coin?.name ?? "")
    }
}
// MARK: - Preview
struct DetailAddPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAddPortfolioView(coin: .constant(Coin.example))
    }
}
