//
//  HomeViewModel.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import Foundation
import Combine
import UIKit

class HomeViewModel: ObservableObject {
    
    @Published var stats: [Stats] = []
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var isLoading:Bool = false
    @Published var searchText: String = ""
    @Published var sortOptions: SortOption = .rank
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let dataController = DataController()
    private var cancellable = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        // update allCoins
        $searchText
        // subscribed to both searchText and allcoins, so any change, this is getting published
            .combineLatest(coinDataService.$allCoins, $sortOptions)
        // wait 0.5 to prevent too fast request from user
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoin) in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancellable)
        
        // Update PortfolioCoins
        $allCoins
            .combineLatest(dataController.$savedEntities)
            .map(mapPortfolio)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedCoin in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioIfNeed(coins: returnedCoin)
            }
            .store(in: &cancellable)
        
        // Update Market Data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobal)
            .sink { [weak self] returnedStats in
                self?.stats = returnedStats
                // reload data and set false
                self?.isLoading = false
            }
            .store(in: &cancellable)
    } //: Subscriber
    
    func updatePortfolio(coin: Coin, amount: Double) {
        dataController.updatePortfolio(coin: coin, amount: amount)
    }
    func deleteCoinFromPort(coin: Coin) {
        dataController.deletePortfolio(coin: coin)
    }
    private func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var filteredSortedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &filteredSortedCoins)
        return filteredSortedCoins
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
    
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rank, .holdings:
             coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
             coins.sort(by: {$0.rank > $1.rank})
        case .price:
             coins.sort(by: {$0.currentPrice < $1.currentPrice})
        case .priceReversed:
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
        }
    }
    
    private func sortPortfolioIfNeed(coins: [Coin]) -> [Coin] {
        // will only sort by holdings
        switch sortOptions {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingValue > $1.currentHoldingValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingValue < $1.currentHoldingValue})
        default:
            return coins
        }
    }
    
    private func mapPortfolio(allCoins: [Coin], portfolioEntities: [Portfolio]) -> [Coin] {
        allCoins
            .compactMap { coin -> Coin? in
                guard let entity = portfolioEntities.first(where: { $0.id == coin.id }) else { return nil }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobal(MarketData: MarketData?, portfolioCoins: [Coin]) -> [Stats] {
        var stats: [Stats] = []
        
        guard let data = MarketData else {
            return stats
        }
        let marketCap = Stats(title: "Market Cap", value: data.marketCap, percentile: data.marketCapChangePercentage24HUsd)
        let volume = Stats(title: "24h Volume", value: data.volume)
        let btcDominance = Stats(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue =
        portfolioCoins
            .map( { $0.currentHoldingValue } )
        // initial value (0), add all (+)
            .reduce(0, +)
        // value changes 24h in percentile
        let previousValue =
        portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingValue
                // 25% -> 25 -> 0.25
                // 2.5 / 100 -> 0.025
                let percentChange = coin.priceChangePercentage24H ?? 0.0 / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentileChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = Stats(title: "Portfolio Value", value: portfolioValue.currencyTo2Digits(), percentile: percentileChange)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    
    func appReloaded() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
    }
}
