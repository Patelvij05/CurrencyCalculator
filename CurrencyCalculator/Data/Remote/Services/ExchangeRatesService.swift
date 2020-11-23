//
//  ExchangeRatesService.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 21/11/20.
//

import Foundation
import Combine

//Live Rates API
//http://api.currencylayer.com/live?access_key=e8e9d4533dcc2c6b583f6fba15686cca

//Live Rates API for specific currency
//http://apilayer.net/api/live?access_key=e8e9d4533dcc2c6b583f6fba15686cca&currencies=INR&source=USD&format=1
enum ExchangeRatesService {
    static let apiClient = ApiClient()
}

extension ExchangeRatesService {
    
    static func requestQuotes() -> AnyPublisher<Rate, Error> {
        
        var components: URLComponents {
            var components = URLComponents()
            components.scheme = "http"
            components.host = "api.currencylayer.com"
            components.path = "/live"
            components.queryItems = [URLQueryItem(name: "access_key", value: "e8e9d4533dcc2c6b583f6fba15686cca")]
            return components
        }
        
        guard let url = components.url else {
            fatalError("Couldn't create URL")
        }
        
        return apiClient.run(URLRequest(url: url))
            .map(\.value)
            .eraseToAnyPublisher()
        
    }
    
    static func requestQuotesForSpecificCurrency(currencies: String) -> AnyPublisher<Rate, Error> {
        
        var components: URLComponents {
            var components = URLComponents()
            components.scheme = "http"
            components.host = "api.currencylayer.com"
            components.path = "/live"
            components.queryItems = [URLQueryItem(name: "access_key", value: "e8e9d4533dcc2c6b583f6fba15686cca"),
                                     URLQueryItem(name: "currencies", value: currencies),
                                     URLQueryItem(name: "source", value: "USD"),
                                     URLQueryItem(name: "format", value: "1")]
            return components
        }
        
        guard let url = components.url else {
            fatalError("Couldn't create URL")
        }
        
        return apiClient.run(URLRequest(url: url))
            .map(\.value)
            .eraseToAnyPublisher()
        
    }
    
}
