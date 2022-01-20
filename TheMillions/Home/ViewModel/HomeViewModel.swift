//
//  HomeViewModel.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var stats: [Stats] = [
        Stats(title: "Title", value: "Value", percentile: 10),
        Stats(title: "Title", value: "Value"),
        Stats(title: "Title", value: "Value"),
        Stats(title: "Title", value: "Value", percentile: -10)
    ]
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        // update allCoins
        $searchText
        // subscribed to both searchText and allcoins, so any change, this is getting published
            .combineLatest(dataService.$allCoins)
        // wait 0.5 to prevent too fast request from user
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoin) in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancellable)
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
}
