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
                // MARK: Textfield
                TextField("PlaceholderValue".localized(), text: $amount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                
                HStack {
                    // MARK: Dropdown
                    DropdownView(currency: self.$base_currency, showCurrencySelection: self.$showCurrencySelection)
                        .sheet(isPresented: self.$showCurrencySelection) {
                            if self.managedCurrency.count == 0 {
                                Text("")
                                    .frame(width: 0, height: 0)
                                    .onAppear {
                                        self.showErrorAlert = true
                                    }
                                    .alert(isPresented: self.$showErrorAlert) {
                                        Alert(
                                            title: Text("ErrorNetTitle".localized()),
                                            message: Text("ErrorNetBody".localized()),
                                            primaryButton: .default(Text("ErrorRetry")) {
                                                self.showErrorAlert = false
                                                self.viewModel.reFetchCurrency()
                                            },
                                            secondaryButton: .cancel(Text("ErrorBack")) {
                                                self.showErrorAlert = false
                                                self.showCurrencySelection.toggle()
                                            }
                                        )
                                    }
                            } else {
                                CurrencySelectionView(
                                    showCurrencySelection: self.$showCurrencySelection,
                                    selection: $base_currency)
                                    .environment(\.managedObjectContext, self.viewContext)
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
                        }
                        .onAppear(){
                            if monitor.isConnected {
                                self.viewModel.fetchCurrencyList()
                            }
                        }
                    
                    // MARK: Exchange Rates View
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
                
                // MARK: On Currency Fetched
                if self.viewModel.currencyFetched {
                    Text("")
                        .frame(width: 0, height: 0)
                        .onAppear {
                            DispatchQueue.main.async {
                                self.storeCurrencyListLocally()
                            }
                        }
                }
                
                // MARK: On Rates Fetched
                if self.viewModel.ratesFetched {
                    Text("")
                        .frame(width: 0, height: 0)
                        .onAppear {
                            DispatchQueue.main.async {
                                self.storeRateListLocally()
                            }
                        }
                }
                
                // MARK: On Result Error
                if self.viewModel.error != nil {
                    if self.managedRate.count == 0 {
                        Text("")
                            .frame(width: 0, height: 0)
                            .onAppear {
                                self.showErrorAlert = true
                            }
                            .alert(isPresented: self.$showErrorAlert) {
                                Alert(
                                    title: Text("ErrorNetTitle".localized()),
                                    message: Text("ErrorNetBody".localized()),
                                    primaryButton: .default(Text("ErrorRetry")) {
                                        self.showErrorAlert = false
                                        self.viewModel.reFetchCurrencyRates()
                                    },
                                    secondaryButton: .cancel(Text("ErrorBack"))
                                )
                            }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("AppName".localized())
        }
    }
}

extension CurrencyList {
    
    // MARK: Save Data Locally
    private func saveData() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Clear Existing Rates
    private func clearExistingRates() {
        managedRate.forEach { rate in
            viewContext.delete(rate)
        }
        saveData()
    }
    
    // MARK: Clear Existing Currency
    private func clearExistingCurrency() {
        managedCurrency.forEach { currency in
            viewContext.delete(currency)
        }
        saveData()
    }
    
    // MARK: Store Currency Locally
    private func storeCurrencyListLocally() {
        self.clearExistingCurrency()
        viewModel.dataCurrency.forEach { key, value in
            let manageCurrency = ManageCurrencyList(context: viewContext)
            manageCurrency.name = key
            manageCurrency.fullname = viewModel.dataCurrency[key]
            saveData()
        }
    }
    
    // MARK: Store Rates Locally
    private func storeRateListLocally() {
        self.clearExistingRates()
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
            
            manageRate.source = source ?? "BaseCurrency".localized()
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
