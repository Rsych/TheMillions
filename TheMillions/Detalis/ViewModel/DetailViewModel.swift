//
//  DetailViewModel.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/23.
//

import Combine
import UIKit

class DetailViewModel: ObservableObject {
    
    @Published var overviewStats: [Stats] = []
    @Published var additionalStats: [Stats] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    @Published var twitterURL: String? = nil
    
    @Published var coin: Coin
    private let coinDetailService: CoinDetailService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailService = CoinDetailService(coin: coin)
        self.addSubscribers()
        
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapStats)
            .sink { [weak self] returnedArrays in
                print("Received coin detail data")
                self?.overviewStats = returnedArrays.overview
                self?.additionalStats = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        // subscribe details
        coinDetailService.$coinDetails
            .sink { [weak self] returnedCoinDetail in
                self?.coinDescription = returnedCoinDetail?.readableDescription
                self?.websiteURL = returnedCoinDetail?.links?.homepage?.first
                self?.redditURL = returnedCoinDetail?.links?.subredditURL
                self?.twitterURL = returnedCoinDetail?.links?.twitterScreenName
            }
            .store(in: &cancellables)
    }
    
    private func mapStats(coinDetailModel: CoinDetail?, coinModel: Coin) -> (overview: [Stats], additional: [Stats]) {
        
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        
        return (overviewArray, additionalArray)
    }
    
    func createOverviewArray(coinModel: Coin) -> [Stats] {
        // Overview
        let price = coinModel.currentPrice.currencyTo6Digits()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let pricePercentStat = Stats(title: "Price Changes in %", value: price, percentile: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapPercentStat = Stats(title: "Market Capitalisation", value: marketCap, percentile: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = Stats(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Stats(title: "Volume", value: volume)
        
        let overviewArray: [Stats] = [
            pricePercentStat, marketCapPercentStat, rankStat, volumeStat
        ]
        return overviewArray
    }
    
    func createAdditionalArray(coinDetailModel: CoinDetail?, coinModel: Coin) -> [Stats] {
        // Additional
        let high = coinModel.high24H?.currencyTo6Digits() ?? "N/A"
        let highStats = Stats(title: "24 High", value: high)
        
        let low = coinModel.low24H?.currencyTo6Digits() ?? "N/A"
        let lowStats = Stats(title: "24 Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.currencyTo6Digits() ?? "N/A"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = Stats(title: "24h Price Change", value: priceChange, percentile: pricePercentChange2)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = Stats(title: "24h Market Cap Change", value: marketCapChange, percentile: marketCapPercentChange2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : String(blockTime)
        let blockStat = Stats(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "N/A"
        let hashingStat = Stats(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [Stats] = [
            highStats, lowStats, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        
        return additionalArray
    }
    
    func reloadData() {
        coinDetailService.getCoinDetails()
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
}
