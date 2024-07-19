//
//  CoinDetailsViewModel.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 17/07/2024.
//

import Foundation
import Combine

class CoinDetailsViewModel: ObservableObject {
    private let coinDetailsDetailService: CoinDetailsDataService
    @Published var coinModel: CoinModel?
    @Published var coinDetails: CoinDetailsModel?
    @Published var isLoading: Bool = false
    @Published var description: String? = ""
    @Published var websiteURL: String? = ""
    @Published var redditURL: String? = ""
    @Published var whitepaperURL: String? = ""
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    
    
    init(coin: CoinModel) {
        self.coinModel = coin
        self.coinDetailsDetailService = CoinDetailsDataService(coin: coin)
        self.getCoinDetails()
    }
    
    
    
    private func getCoinDetails() {
        coinDetailsDetailService.$coinDetails
        
            .map(mapCoinDetails)
            .sink { [weak self] (returnedArray) in
                self?.overviewStatistics = returnedArray.overview
                self?.additionalStatistics = returnedArray.additional
            }
            .store(in: &cancellables)
        
        coinDetailsDetailService.$coinDetails
            .sink { [weak self] (returnedDetails) in
                self?.description = returnedDetails?.readableDescription
                self?.websiteURL = returnedDetails?.links?.homepage?.first
                self?.redditURL = returnedDetails?.links?.subredditURL
                self?.whitepaperURL = returnedDetails?.links?.whitepaper
            }
            .store(in: &cancellables)
    }
    
    private func mapCoinDetails(coinDetails: CoinDetailsModel?) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        
        let price = coinModel?.currentPrice.asCurrencyString()
        let priceChangePercentage = coinModel?.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price ?? "", percertageChange: priceChangePercentage)
        
        
        let marketCap = "$" + (coinModel?.marketCap?.formattedWithAbbreviation() ?? "")
        let marketCapPercentageChange = coinModel?.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percertageChange: marketCapPercentageChange)
        
        let rank = "\(coinModel?.rank ?? 0)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel?.totalVolume?.formattedWithAbbreviation() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat,
            marketCapStat,
            rankStat,
            volumeStat,
        ]
        
        
        let high24H = coinModel?.high24H?.asCurrencyString() ?? "n/a"
        let low24H = coinModel?.low24H?.asCurrencyString() ?? "n/a"
        
        let high24HStat = StatisticModel(title: "24h High", value: high24H)
        let low24HStat = StatisticModel(title: "24h Low", value: low24H)
        
        let priceChange = coinModel?.priceChange24H?.asCurrencyString()
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange ?? "")
        
        let marketCapChange = "$" + (coinModel?.marketCapChange24H?.formattedWithAbbreviation() ?? "")
        let marketCapChangePercentage = coinModel?.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percertageChange: marketCapChangePercentage)
        
        let blockTime = coinModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetails?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
    
        
        let additionalArray: [StatisticModel] = [
            high24HStat,
            low24HStat,
            priceChangeStat,
            marketCapChangeStat,
            blockTimeStat,
            hashingStat,
        ]
        
        return (overview: overviewArray, additional: additionalArray)
    }
}
