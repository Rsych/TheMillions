//
//  CoinDataService.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [Coin] = []
    //    // it would be too confusing which to cancellable
    //    var cancellables = Set<AnyCancellable>()
    
    var subscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        subscription = NetworkManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.subscription?.cancel()
            })
    }
}
