//
//  CurrencyListService.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 19/11/20.
//

import Foundation
import Combine

//List API
//http://api.currencylayer.com/list?access_key=e8e9d4533dcc2c6b583f6fba15686cca

enum CurrencyListService {
    static let apiClient = ApiClient()
}

extension CurrencyListService {
    
    static func request() -> AnyPublisher<Currency, Error> {
        
        
        var components: URLComponents {
            var components = URLComponents()
            components.scheme = "http"
            components.host = "api.currencylayer.com"
            components.path = "/list"
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
    
}
