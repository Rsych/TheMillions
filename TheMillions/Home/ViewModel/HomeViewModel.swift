//
//  HomeViewModel.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.allCoins.append(Coin.example)
            self.portfolioCoins.append(Coin.example)
        }
    }
}
