//
//  MarketDataService.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/21.
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketData: MarketData? = nil
    //    // it would be too confusing which to cancellable
    //    var cancellables = Set<AnyCancellable>()
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getDoins()
    }
    private func getDoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
