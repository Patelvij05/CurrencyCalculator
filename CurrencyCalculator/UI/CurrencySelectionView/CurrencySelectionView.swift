//
//  CurrencySelectionView.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 20/11/20.
//

import SwiftUI

struct CurrencySelectionView: View {
    
    @Binding var showCurrencySelection: Bool
    @Binding var dataCurrency: [String: String]
    @Binding var selection: String
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 0) {
                
                List(Array(self.dataCurrency.keys.sorted()), id: \.self) { key in
                    Button(action: {
                        self.selection = key
                        self.showCurrencySelection.toggle()
                    }) {
                        CurrencySelectionRow( currency: "\(key)",
                                              fullName: "\(self.dataCurrency[key]!)")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }.navigationBarTitle(Text("Select Currency"))
        }
    }
    
}

struct CurrencySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionView(
            showCurrencySelection: .constant(true),
            dataCurrency: .constant(["USD": "UD Dollar", "INR": "Indian Rupee", "EUR": "Euro"]),
            selection: .constant("USD")
        )
    }
}
