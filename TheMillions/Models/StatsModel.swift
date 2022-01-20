//
//  StatsModel.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/20.
//

import Foundation

struct Stats: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentile: Double?
    
    init(title: String, value: String, percentile: Double? = nil) {
        self.title = title
        self.value = value
        self.percentile = percentile
    }
    
    static let example = Stats(title: "Market Cap", value: "$45.8Bn", percentile: 21.34)
    static let example2 = Stats(title: "Total Volume", value: "$1.5Tn")
    static let example3 = Stats(title: "Market Cap", value: "$45.8Bn", percentile: -21.34)
}

