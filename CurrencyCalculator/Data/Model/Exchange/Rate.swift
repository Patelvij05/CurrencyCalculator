//
//  Rate.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 19/11/20.
//

import Foundation

struct Rate: Codable, Hashable {

    let id: UUID = UUID()
    var success: Bool
    var source: String
    var quotes: [String: Double]
    var timestamp: Int64

    private enum CodingKeys: String, CodingKey {
        case success, source, quotes, timestamp
    }

}
