//
//  CurrencyCellView.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 21/11/20.
//

import SwiftUI

struct CurrencyCellView: View {
    @Binding var amount: String
    var name: String
    var rate: Double
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text("\((Double(self.amount) ?? 0) * rate, specifier: "TwoDigits".localized())")
        }
    }
}
