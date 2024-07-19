//
//  CoinImageViewModel.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 15/07/2024.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading = false
    
    private let coin: CoinModel
    private let imageDataService: CoinImageDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageDataService = CoinImageDataService(coin: coin)
        self.addSubsribers()
        self.isLoading = true
    }
    
    private func addSubsribers() {
      imageDataService.$image.sink { [weak self] (_) in
          self?.isLoading = false
         
      } receiveValue: { [weak self] returnedImage in
          self?.image = returnedImage
      }
      .store(in: &cancellables)
      
    }
}
