//
//  Currency.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 19/11/20.
//

import Foundation
import Combine

struct Currency: Codable, Hashable {
    
    let id: UUID = UUID()
    let success: Bool
    let currencies: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case success, currencies
    }
    
}
