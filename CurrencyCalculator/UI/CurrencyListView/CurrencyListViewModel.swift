//
//  CurrencyListViewModel.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 20/11/20.
//

import SwiftUI
import Combine

class CurrencyListViewModel: ObservableObject {
    
    @Published var dataCurrency: [String: String] = [:]
    @Published var data: [String: Double] = [:]
    @Published private(set) var error: Error? = nil
    @Published private(set) var ratesFetched: Bool = false
    var fetchedRates: Set<Rate> = []
    var cancellable: AnyCancellable?
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.fetchQuotesList()
        }
    }
}

extension CurrencyListViewModel {
    
    func reFetchCurrencyRates() {
        ratesFetched = false
        error = nil
        fetchQuotesList()
    }
    
    func fetchCurrencyList() {
        cancellable = CurrencyListService.request()
            .mapError({ (error) -> Error in
                self.error = error
                print("Returned error: \(self.error.debugDescription)")
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: { currency in
                    self.dataCurrency = currency.currencies
                  })
    }
    
    func fetchQuotesList() {
        cancellable = ExchangeRatesService.requestQuotes()
            .mapError({ (error) -> Error in
                self.error = error
                print("Returned error: \(self.error.debugDescription)")
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: { rate in
                    self.data = rate.quotes
                    self.fetchedRates.insert(rate)
                    
                    if self.data.count > 0 {
                        self.ratesFetched = true
                    }
                    
                  })
    }
    
    /*func fetchQuoteForSpecificCurrency() {
     cancellable = ExchangeRatesService.requestQuotes()
     .mapError({ (error) -> Error in
     self.error = error
     print("Returned error: \(self.error.debugDescription)")
     return error
     })
     .sink(receiveCompletion: { _ in },
     receiveValue: { rate in
     self.data = rate.quotes
     self.fetchedRates.insert(rate)
     print("Returned data: \(self.data)")
     })
     }*/
    
}
