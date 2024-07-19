//
//  CoinImageDataService.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 15/07/2024.
//

import Foundation
import Combine
import SwiftUI


class CoinImageDataService {
    @Published var image: UIImage? = nil
    var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager =  LocalFileManagers.instance
    private let folderName = "coin_image"
    private let imageName: String

    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage =  fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("Received Image from File Manager")
        } else {
            downloadCoinImage()
            
        }
    }
    
    private func downloadCoinImage() {
        guard let urlImage = URL(string: coin.image) else { return }
        
        let requestImage = URLRequest(url: urlImage)

        imageSubscription = NetworkingManager.download(url: requestImage)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data) 
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadImage = returnedImage else {return}
                self.image = downloadImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
            }
                  )
    }
}
