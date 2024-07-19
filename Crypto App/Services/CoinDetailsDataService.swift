//
//  CoinDetailsDataService.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 17/07/2024.
//

import Foundation
import Combine


class CoinDetailsDataService {
    @Published var coinDetails: CoinDetailsModel? = nil
    var coinDetailsSubscription: AnyCancellable?
    
    init(coin: CoinModel) {
        getCoinDetails(coin: coin)
    }
    
    
//https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
    func getCoinDetails(coin: CoinModel) {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
//        convert url to URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("x-cg-demo-api-key", forHTTPHeaderField: "CG-Vbd1N5wPLLmYd3xHHvLHsKXj")
        
        coinDetailsSubscription = NetworkingManager.download(url: urlRequest)
            .decode(type: CoinDetailsModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion:  NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetails) in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailsSubscription?.cancel()
            })
        
    }
}


