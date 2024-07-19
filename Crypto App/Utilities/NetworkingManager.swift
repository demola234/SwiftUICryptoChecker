//
//  NetworkingManager.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 15/07/2024.
//

import Foundation
import Combine

enum NetworkError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(url: let url):
            return "[🔥] Bad response from URL: \(url)"
        case .unknown:
            return "[⚠️] Unknown error occurred"
        }
    }
}

class NetworkingManager {
    static func download(url: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({try handleUrlResponse(output: $0) })
            .receive(on: DispatchQueue.main)
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output) throws-> Data {
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
          throw  NetworkError.badURLResponse(url: output.response.url ?? URL(string: "n/a")!)
        }
        return output.data
    }
}
