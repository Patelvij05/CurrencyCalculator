//
//  ExchangeRatesService.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 21/11/20.
//

import Foundation
import Combine

enum ExchangeRatesService {
    static let apiClient = ApiClient()
}

extension ExchangeRatesService {
    
    // MARK: Request to Fetch Exchange Rates
    static func requestQuotes() -> AnyPublisher<Rate, Error> {
        
        var components: URLComponents {
            var components = URLComponents()
            components.scheme = CurrencyListService.httpProtocal
            components.host = CurrencyListService.baseURL
            components.path = CurrencyListService.livePath
            components.queryItems = [URLQueryItem(name: CurrencyListService.accessKey, value: CurrencyListService.token)]
            return components
        }
        
        guard let url = components.url else {
            fatalError("URLError".localized())
        }
        
        return apiClient.run(URLRequest(url: url))
            .map(\.value)
            .eraseToAnyPublisher()
        
    }
    
}
