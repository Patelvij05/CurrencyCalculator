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

extension Rate {

//    // Converts from a managed object directly to a Rate object
//    static func managedRateAsRate(rate: ManageRateList, currencyRates: [ManageCurrencyRate]) -> Rate {
//        Rate(
//            success: false,
//            source: rate.source ?? "",
//            quotes: Dictionary(
//                uniqueKeysWithValues: currencyRates.map {
//                    ($0.name ?? "", Double(truncating: $0.value ?? 0.0 )))
//                }
//            ),
//            timestamp: 0
//
//        )
//    }

}
