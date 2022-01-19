//
//  CoinModel.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import Foundation
/*
 CoinGecko API url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
 
 JSON response :
 {
 "id": "bitcoin",
 "symbol": "btc",
 "name": "Bitcoin",
 "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
 "current_price": 42188,
 "market_cap": 798850478286,
 "market_cap_rank": 1,
 "fully_diluted_valuation": 886013677026,
 "total_volume": 20030373396,
 "high_24h": 42621,
 "low_24h": 41244,
 "price_change_24h": 675.01,
 "price_change_percentage_24h": 1.62605,
 "market_cap_change_24h": 11574318161,
 "market_cap_change_percentage_24h": 1.47017,
 "circulating_supply": 18934087,
 "total_supply": 21000000,
 "max_supply": 21000000,
 "ath": 69045,
 "ath_change_percentage": -38.89309,
 "ath_date": "2021-11-10T14:24:11.849Z",
 "atl": 67.81,
 "atl_change_percentage": 62120.54223,
 "atl_date": "2013-07-06T00:00:00.000Z",
 "roi": null,
 "last_updated": "2022-01-19T14:21:34.055Z",
 "sparkline_in_7d": {
 "price": [
 43178.3020044094,
 43286.3461468275
 ]
 },
 "price_change_percentage_24h_in_currency": 1.6260475817608957
 }
 */

struct Coin: Identifiable, Codable {
    let id, symbol, name: String
    let image: String?
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    // Update holdings on current selected coin
    func updateHoldings(amount: Double) -> Coin {
        return Coin(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingValue: Double {
        return (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
    
    static let example = Coin(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
        currentPrice: 42565,
        marketCap: 802829252201,
        marketCapRank: 1,
        fullyDilutedValuation: 890425966706,
        totalVolume: 67190952980,
        high24H: 42621,
        low24H: 41244,
        priceChange24H: 1067.63,
        priceChangePercentage24H: 2.57277,
        marketCapChange24H: 19924401585,
        marketCapChangePercentage24H: 2.54493,
        circulatingSupply: 18934100,
        totalSupply: 21000000,
        maxSupply: 21000000,
        ath: 69045,
        athChangePercentage: -38.58878,
        athDate: "2021-11-10T14:24:11.849Z",
        atl: 67.81,
        atlChangePercentage: 90020.24075,
        atlDate: "2013-07-06T00:00:00.000Z",
        lastUpdated: "2022-01-19T14:45:20.329Z",
        sparklineIn7D: SparklineIn7D(price: [
            43178.3020044094,
            43286.3461468275,
            44142.95617046611,
            43954.05064468909,
            43537.75551153419,
            43714.08929251948,
            43946.62531700104,
            43643.559182658464,
            43830.018518688914,
            44079.045729932375,
            43851.179214070566,
            43933.94798971295,
            43981.87732717414,
            43702.3823096264,
            43585.47818629988,
            43628.98833147167,
            43545.54886489405,
            43692.499996266684,
            43743.26864684281,
            43705.251773803444,
            43754.37515992663,
            43920.6078574499,
            43890.03403522622,
            43880.251837517484,
            43680.55986683123,
            43816.41969175357,
            43991.10705362516,
            44046.08436602141,
            42979.593359374114,
            43324.93335811952,
            42817.17658254182,
            42743.748516695814,
            42724.89581260096,
            42720.94616556062,
            42899.81519999951,
            42641.77574380057,
            42608.41001195019,
            42822.3410626846,
            42630.730370044825,
            42827.69538217487,
            42780.31638262786,
            42727.79226823351,
            42894.38226108194,
            42899.36778267711,
            42638.96747016387,
            42574.67989666804,
            42644.981834357044,
            42086.466454609246,
            42024.69661257974,
            42271.47151393987,
            42203.4285747024,
            43396.856151091495,
            43094.85541933739,
            43318.02949176713,
            42937.290331282704,
            43093.48998490977,
            43254.93326852252,
            43167.941146500394,
            43494.76826815796,
            43433.83319474636,
            43191.97077835075,
            43204.25614289687,
            43008.05726400687,
            43149.46797893759,
            43018.88169344696,
            43002.59260903966,
            43143.71368441771,
            43169.33853917334,
            43106.31841360756,
            43089.40095195211,
            43038.46408581668,
            43194.632756373794,
            43049.23746683092,
            42669.96652910112,
            43142.38806679312,
            43333.255381162264,
            43495.44513376632,
            43448.40684692052,
            43593.93677461069,
            43418.60863310491,
            43512.82658701286,
            43621.32296679522,
            43314.19235421247,
            43323.334689302115,
            43173.14113478345,
            43110.52062155796,
            43106.50936358114,
            42979.252744066725,
            43088.96743528128,
            43093.090288479245,
            43071.30042435913,
            43243.98300180644,
            43298.474670668285,
            43145.36827843491,
            43138.66543732607,
            43065.09759884792,
            43084.29328016314,
            43146.87895287532,
            43137.900230492865,
            43359.673918935296,
            43234.84803526138,
            43445.73263441537,
            43111.24443881516,
            43111.69338321902,
            42819.45590325531,
            43172.13965861911,
            43047.85859702999,
            43225.92579999611,
            43119.79214308028,
            42877.858416602336,
            42899.268988348034,
            42989.70122789917,
            42749.711818578595,
            42712.08236994989,
            42599.83212961661,
            42843.846816992016,
            42718.431064867356,
            42918.18830305879,
            42953.704362756995,
            42848.42337504775,
            42787.2565709712,
            42666.07903883221,
            42682.25091040553,
            42706.84109519157,
            42554.380859461504,
            42288.63596857892,
            42117.89357566385,
            42292.17977430048,
            42331.65604621167,
            42213.655228582276,
            41756.89208374346,
            42346.541012394795,
            42311.13096812778,
            42420.84387886949,
            42305.94587540152,
            42310.62962338389,
            42073.464694362105,
            42104.48450429597,
            42243.993380507665,
            42415.20222337461,
            42085.76408393512,
            41774.58393396233,
            42055.251604425226,
            42058.93212053518,
            41843.44735603253,
            41889.82064061213,
            41727.002021779736,
            41356.61112815827,
            41702.56259168864,
            41796.53046970178,
            41550.28411391625,
            41716.19509209493,
            41812.879241771945,
            41741.91803252099,
            42498.18123135277,
            42498.47853946216,
            42395.45879157343,
            42332.290976869364,
            42454.98929665433,
            42334.4404296046,
            41779.01270893919,
            41820.97346316072,
            41778.45401628946,
            41781.40839917395,
            41265.005495175465,
            41325.06579035713,
            41658.36261134919,
            41455.42789267524
        ]),
        priceChangePercentage24HInCurrency: 2.5727728693402194,
        currentHoldings: 1)
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
