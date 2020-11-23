//
//  ContentView.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 19/11/20.
//

import SwiftUI
import CoreData

struct CurrencyList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ManageCurrencyList.name, ascending: true)],
        animation: .default)
    private var managedCurrency: FetchedResults<ManageCurrencyList>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ManageRateList.currency, ascending: true)],
        animation: .default)
    private var managedRate: FetchedResults<ManageRateList>
    
    @StateObject private var viewModel = CurrencyListViewModel()
    
    @State private var base_currency: String = "USD"
    @State var amount = "1"
    @State var exchangeRate: Double = 1.0
    @State private var showCurrencySelection: Bool = false
    @State private var showErrorAlert: Bool = false
    let timer = Timer.publish(every: 30*60, on: .main, in: .common).autoconnect()
    
    @ObservedObject var monitor = NetworkMonitor()
    @State private var showAlertSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("$1", text: $amount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                
                HStack {
                    // MARK: Dropdown
                    DropdownView(currency: self.$base_currency, showCurrencySelection: self.$showCurrencySelection)
                        .sheet(isPresented: self.$showCurrencySelection) {
                            CurrencySelectionView(
                                showCurrencySelection: self.$showCurrencySelection,
                                dataCurrency: $viewModel.dataCurrency,
                                selection: $base_currency)
                                .onDisappear {
                                    DispatchQueue.main.async {
                                        for rate in self.managedRate {
                                            if rate.currency == base_currency {
                                                exchangeRate = rate.value
                                            }
                                        }
                                    }
                                }
                        }
                        .onAppear(){
                            self.viewModel.fetchCurrencyList()
                        }
                    
                    // MARK: Selected Currency Exchange Rates
                    ExchangeRateView(amount: $amount, rate: $exchangeRate)
                    
                }
                
                // MARK: Exchange Rates List
                List(self.managedRate, id: \.self) { rate in
                        CurrencyCellView(amount: self.$amount,
                                         name: rate.currency ?? "",
                                         rate: rate.value)
                    
                }
                .onReceive(timer) { _ in
                    if monitor.isConnected {
                        self.viewModel.fetchQuotesList()
                    }
                }
                
                // MARK: On Results Fetched
                if self.viewModel.ratesFetched {
                    Text("")
                        .frame(width: 0, height: 0)
                        .onAppear {
                            DispatchQueue.main.async {
                                self.clearExistingRates()
                                self.storeRateListLocally()
                            }
                        }
                }
                
                // MARK: On Result Error
                if self.viewModel.error != nil {
                    Text("")
                        .frame(width: 0, height: 0)
                        .onAppear {
                            self.showErrorAlert = true
                        }
                        .alert(isPresented: self.$showErrorAlert) {
                            Alert(
                                title: Text("ErrorNetTitle"),
                                message: Text("ErrorNetBody"),
                                primaryButton: .default(Text("ErrorRetry")) {
                                    self.showErrorAlert = false
                                    self.viewModel.reFetchCurrencyRates()
                                },
                                secondaryButton: .cancel(Text("ErrorBack"))
                            )
                        }
                }
                
                Spacer()
            }
            .navigationTitle("Currency Calculator")
            .alert(isPresented: $showAlertSheet, content: {
                if monitor.isConnected {
                return Alert(title: Text("Success!"), message: Text("The network request can be performed."), dismissButton: .default(Text("OK")))
                }
                return Alert(title: Text("No Internet Connection!"), message: Text("Please enable Wifi or Cellular data."), dismissButton: .default(Text("Cancel")))
                })
        }
    }
}

extension CurrencyList {
    
    private func saveData() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func clearExistingRates() {
        managedRate.forEach { rate in
            viewContext.delete(rate)
        }
        saveData()
    }
    
//    private func storeCurrencyListLocally() {
//        viewModel.dataCurrency.forEach { key, value in
//            let manageCurrency = ManageCurrencyList(context: viewContext)
//            manageCurrency.name = key
//            manageCurrency.fullname = viewModel.dataCurrency[key]
//            saveData()
//        }
//    }
    
    private func storeRateListLocally() {
        var timestamp: Int64?
        var source: String?
        viewModel.data.forEach { key, value in
            let manageRate = ManageRateList(context: viewContext)
            manageRate.currency = key.trimmed()
            manageRate.value = viewModel.data[key] ?? 0.0
            
            viewModel.fetchedRates.forEach { rate in
                timestamp = rate.timestamp
                source = rate.source
            }
            
            manageRate.source = source ?? "USD"
            manageRate.timestamp = timestamp ?? 0
            saveData()
        }
        
    }
    
}

struct CurrencyList_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        //CurrencyList().environment(\.colorScheme, .dark)
    }
}
