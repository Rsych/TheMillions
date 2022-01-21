//
//  HomeViewModel.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var stats: [Stats] = []
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        // update allCoins
        $searchText
        // subscribed to both searchText and allcoins, so any change, this is getting published
            .combineLatest(coinDataService.$allCoins)
        // wait 0.5 to prevent too fast request from user
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoin) in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancellable)
        
        // Update Market Data
        marketDataService.$marketData
            .map(mapGlobal)
            .sink { [weak self] returnedStats in
                self?.stats = returnedStats
            }
            .store(in: &cancellable)
        
        // Update PortfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [Coin] in
                coinModels
                    .compactMap { coin -> Coin? in
                        guard let entity = portfolioEntities.first(where: { $0.id == coin.id }) else { return nil }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] returnedCoin in
                self?.portfolioCoins = returnedCoin
            }
            .store(in: &cancellable)
    } //: Subscriber
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobal(MarketData: MarketData?) -> [Stats] {
        var stats: [Stats] = []
        
        guard let data = MarketData else {
            return stats
        }
        let marketCap = Stats(title: "Market Cap", value: data.marketCap, percentile: data.marketCapChangePercentage24HUsd)
        let volume = Stats(title: "24h Volume", value: data.volume)
        let btcDominance = Stats(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = Stats(title: "Portfolio Value", value: "$0.00", percentile: 0)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
