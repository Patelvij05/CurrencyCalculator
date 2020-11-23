//
//  CurrencyListService.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 19/11/20.
//

import Foundation
import Combine

enum CurrencyListService {
    static let apiClient = ApiClient()
    static let httpProtocal = "http"
    static let baseURL = "api.currencylayer.com"
    static let listPath = "/list"
    static let livePath = "/live"
    static let accessKey = "access_key"
    static let token = "e8e9d4533dcc2c6b583f6fba15686cca"
}

extension CurrencyListService {
    
    static func request() -> AnyPublisher<Currency, Error> {
        
        
        var components: URLComponents {
            var components = URLComponents()
            components.scheme = httpProtocal
            components.host = baseURL
            components.path = listPath
            components.queryItems = [URLQueryItem(name: accessKey, value: token)]
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
