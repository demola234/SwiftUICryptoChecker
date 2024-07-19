//
//  HomeViewModel.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 14/07/2024.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var statistics: [StatisticModel] = []
    @Published var sortOption: softOption = .holdings
    @Published var isLoading: Bool = false
    
    
    @Published var searchText: String = ""
    
    private let marketDataService = MarketDataService()
    private let dataService = CoinDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum softOption {
        case rank, rankReversed, price, priceReversed, holdings, holdingsReversed
    }
    
    init() {
        addSubscriber()
    }
    

    func addSubscriber() {
        $searchText
            .combineLatest(dataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
        $allCoins.combineLatest(portfolioDataService.$savedEntities)
            .map(mapPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins =  self.sortPorfolioIfNeeded(coin: returnedCoins)
            }
            .store(in: &cancellables)
    }
    
    func reloadData() {
        isLoading = true
        dataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    func sortPorfolioIfNeeded(coin: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .rank:
            return coin.sorted(by: { $0.rank < $1.rank })
        case .rankReversed:
            return coin.sorted(by: { $0.rank > $1.rank })
        case .price:
            return coin.sorted(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            return coin.sorted(by: { $0.currentPrice < $1.currentPrice })
        case .holdings:
            return coin.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coin.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        }
        
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: softOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        
        switch sortOption {
        case .rank, .holdings:
            updatedCoins.sort { $0.rank < $1.rank }
        case .rankReversed:
            updatedCoins.sort { $0.rank > $1.rank }
        case .price:
            updatedCoins.sort { $0.currentPrice > $1.currentPrice }
        case  .priceReversed:
            updatedCoins.sort { $0.currentPrice < $1.currentPrice }
        case .holdingsReversed:
            updatedCoins.sort { $0.currentHoldingsValue < $1.currentHoldingsValue }
        }
        
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercaseText = text.lowercased()
        
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowercaseText) ||
                   coin.symbol.lowercased().contains(lowercaseText) ||
                   coin.id.lowercased().contains(lowercaseText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percertageChange: data.marketCapChangePercentage24HUsd)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.bitcoinDominance)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let porfolioValue = portfolioCoins.map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        let previousValue =  portfolioCoins.map{ (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentageChange = coin.priceChangePercentage24H! / 100
            let previousValue = currentValue / (1 + percentageChange)
            return previousValue
        }
            .reduce(0, +)
        
        let percentageChange = ((porfolioValue - previousValue) / previousValue) * 100
            
        
        let portfolio = StatisticModel(title: "Portfolio", value: porfolioValue.asCurrencyString(), percertageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio ])
        return stats
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfio(coin: coin, amount: amount)
    }
    
    private func mapPortfolioCoins(allCoins: [CoinModel], portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { (coin) -> CoinModel? in
            let coin = coin
            guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id }) else {
             return nil
            }
            return coin.updateHoldings(ammount: entity.amount)
        }
    }
    
    
}
