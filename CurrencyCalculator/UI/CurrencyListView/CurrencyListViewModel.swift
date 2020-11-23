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
    @Published private(set) var currencyFetched: Bool = false
    var fetchedRates: Set<Rate> = []
    var cancellable: AnyCancellable?
    
    init() {
        // MARK: Fetch Exchange Rates
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.fetchQuotesList()
        }
    }
}

extension CurrencyListViewModel {
    
    // MARK: Retry Fetch Currency List
    func reFetchCurrency() {
        ratesFetched = false
        error = nil
        fetchCurrencyList()
    }
    
    // MARK: Retry Fetch Exchange Rates
    func reFetchCurrencyRates() {
        ratesFetched = false
        error = nil
        fetchQuotesList()
    }
    
    // MARK: Fetch Currency List
    func fetchCurrencyList() {
        cancellable = CurrencyListService.request()
            .mapError({ (error) -> Error in
                self.error = error
                //print("Returned error: \(self.error.debugDescription)")
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: { currency in
                    self.dataCurrency = currency.currencies
                    
                    if self.dataCurrency.count > 0 {
                        self.currencyFetched = true
                    }
                  })
    }
    
    // MARK: Fetch Exchange Rate List
    func fetchQuotesList() {
        cancellable = ExchangeRatesService.requestQuotes()
            .mapError({ (error) -> Error in
                self.error = error
                //print("Returned error: \(self.error.debugDescription)")
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
    
}
