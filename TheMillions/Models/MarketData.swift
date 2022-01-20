//
//  MarketData.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/20.
//

import Foundation
// JSON data
/*
 
 URL : https://api.coingecko.com/api/v3/global
 
 RESPONSE:
 {
 "data": {
 "active_cryptocurrencies": 12644,
 "upcoming_icos": 0,
 "ongoing_icos": 50,
 "ended_icos": 3375,
 "markets": 722,
 "total_market_cap": {
 "btc": 49572372.52887275,
 "eth": 667442566.4395972,
 "ltc": 15314949188.158363,
 "bch": 5574866378.29524,
 "bnb": 4597263982.594119,
 "eos": 763063946805.1337,
 "xrp": 2808426353629.5034,
 "xlm": 8625476618498.556,
 "link": 97649929821.43355,
 "dot": 87608794946.78036,
 "yfi": 64478590.050816655,
 "usd": 2071182640441.8506,
 "aed": 7607453838342.907,
 "ars": 215990916367903.03,
 "aud": 2866291015463.708,
 "bdt": 178106819417179.28,
 "bhd": 780697086209.6686,
 "bmd": 2071182640441.8506,
 "brl": 11224981438138.625,
 "cad": 2589423604820.0063,
 "chf": 1899798490493.2065,
 "clp": 1661937662516944.8,
 "cny": 13133369123041.75,
 "czk": 44464353972087.01,
 "dkk": 13630488166852.674,
 "eur": 1831263056920.988,
 "gbp": 1523176710337.9,
 "hkd": 16127039942075.307,
 "huf": 653158130894577.2,
 "idr": 29680075902699444,
 "ils": 6473874867402.691,
 "inr": 154129353130028.66,
 "jpy": 236393625204613.1,
 "krw": 2469928112143265.5,
 "kwd": 625950746411.6947,
 "lkr": 419501466075642.4,
 "mmk": 3683326845761230.5,
 "mxn": 42549771379906.33,
 "myr": 8675148489490.698,
 "ngn": 859437236651346.4,
 "nok": 18304652373678.863,
 "nzd": 3065685839441.688,
 "php": 106470183365598.52,
 "pkr": 365460176905964.25,
 "pln": 8287102065890.684,
 "rub": 158595425616969.4,
 "sar": 7768668481526.999,
 "sek": 19123063624588.367,
 "sgd": 2790373886960.9556,
 "thb": 68100485217728.195,
 "try": 27667271947550.285,
 "twd": 57239201380068.23,
 "uah": 58670962302204.875,
 "vef": 207387517787.44217,
 "vnd": 47046913677636600,
 "zar": 31565237676861.88,
 "xdr": 1473499394706.9055,
 "xag": 84676449854.7539,
 "xau": 1126081289.781828,
 "bits": 49572372528872.75,
 "sats": 4957237252887275
 },
 "total_volume": {
 "btc": 1850753.389860007,
 "eth": 24918548.969095245,
 "ltc": 571774007.9720647,
 "bch": 208134134.42411074,
 "bnb": 171635963.05405352,
 "eos": 28488513141.20613,
 "xrp": 104850833821.29129,
 "xlm": 322026751524.6851,
 "link": 3645698791.829029,
 "dot": 3270819328.5456824,
 "yfi": 2407267.657815615,
 "usd": 77326302883.41216,
 "aed": 284019510490.77246,
 "ars": 8063885189558.746,
 "aud": 107011174623.62796,
 "bdt": 6649506226508.307,
 "bhd": 29146835324.753216,
 "bmd": 77326302883.41216,
 "brl": 419077631106.9395,
 "cad": 96674503759.38507,
 "chf": 70927783298.71837,
 "clp": 62047398696678.734,
 "cny": 490326086583.71564,
 "czk": 1660048725605.0762,
 "dkk": 508885713822.8833,
 "eur": 68369055936.30635,
 "gbp": 56866845708.70155,
 "hkd": 602092906160.9777,
 "huf": 24385248540680.51,
 "idr": 1108086990515327.5,
 "ils": 241698051659.65268,
 "inr": 5754322583939.018,
 "jpy": 8825607508172.3,
 "krw": 92213214600475.84,
 "kwd": 23369477931.121906,
 "lkr": 15661823729306.842,
 "mmk": 137514694132997.9,
 "mxn": 1588568987156.376,
 "myr": 323881219627.1721,
 "ngn": 32086549381471.9,
 "nok": 683392698444.3552,
 "nzd": 114455455128.51701,
 "php": 3974997417525.838,
 "pkr": 13644226143778.066,
 "pln": 309393750150.4492,
 "rub": 5921060594909.783,
 "sar": 290038357928.3094,
 "sek": 713947568418.3137,
 "sgd": 104176856317.73949,
 "thb": 2542488838806.597,
 "try": 1032940219177.1947,
 "twd": 2136989629159.6714,
 "uah": 2190443523838.0051,
 "vef": 7742682707.716047,
 "vnd": 1756466969996706,
 "zar": 1178468321203.7776,
 "xdr": 55012174334.04304,
 "xag": 3161342066.464946,
 "xau": 42041537.614682294,
 "bits": 1850753389860.007,
 "sats": 185075338986000.7
 },
 "market_cap_percentage": {
 "btc": 38.19768761112105,
 "eth": 17.891085632547725,
 "usdt": 3.7261731543924834,
 "bnb": 3.6597980467862348,
 "usdc": 2.2210692929527736,
 "ada": 2.0426827297776446,
 "sol": 2.0261928832645806,
 "xrp": 1.696973972420492,
 "luna": 1.3792785042172508,
 "dot": 1.2289147081384546
 },
 "market_cap_change_percentage_24h_usd": -0.44982160369596524,
 "updated_at": 1642715820
 }
 }
 */

// MARK: - MarketData
struct GlobalData: Codable {
    let data: MarketData?
}

// MARK: - DataClass
struct MarketData: Codable {
    let activeCryptocurrencies, upcomingIcos, ongoingIcos, endedIcos: Int?
    let markets: Int?
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    let updatedAt: Int?

    enum CodingKeys: String, CodingKey {
        case activeCryptocurrencies = "active_cryptocurrencies"
        case upcomingIcos = "upcoming_icos"
        case ongoingIcos = "ongoing_icos"
        case endedIcos = "ended_icos"
        case markets
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
        case updatedAt = "updated_at"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: {$0.key == "usd"}) {
            return "\(item.value)"
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: {$0.key == "usd"}) {
            return "\(item.value)"
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}) {
            return item.value.percentToString()
        }
        return ""
    }
}
