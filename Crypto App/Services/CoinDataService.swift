//
//  CoinDataService.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 15/07/2024.
//
import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?

    init() {
        getCoins()
    }

     func getCoins() {
        guard let url = URL(string:"https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true") else { return }
        
        var request = URLRequest(url: url)
        request.addValue("CG-Vbd1N5wPLLmYd3xHHvLHsKXj", forHTTPHeaderField: "x-cg-demo-api-key")

        coinSubscription = NetworkingManager.download(url: request)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                print("Received coins: \(returnedCoins)")
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            }
                  )
    }
}
