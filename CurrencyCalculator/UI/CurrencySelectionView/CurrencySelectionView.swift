//
//  CurrencySelectionView.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 20/11/20.
//

import SwiftUI

struct CurrencySelectionView: View {
    
    @Binding var showCurrencySelection: Bool
    @Binding var selection: String
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ManageCurrencyList.name, ascending: true)],
        animation: .default)
    private var managedCurrency: FetchedResults<ManageCurrencyList>
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 0) {
                List(self.managedCurrency, id: \.self) { currency in
                    Button(action: {
                        self.selection = currency.name ?? "BaseCurrency".localized()
                        self.showCurrencySelection.toggle()
                    }) {
                        CurrencySelectionRow( currency: "\(currency.name ?? "BaseCurrency".localized())",
                                              fullName: "\(currency.fullname ?? "BaseCurrencyFullName".localized())")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }.navigationBarTitle(Text("Selection".localized()))
        }
    }
    
}

struct CurrencySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionView(
            showCurrencySelection: .constant(true),
            selection: .constant("BaseCurrency".localized())
        )
    }
}
