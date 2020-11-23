//
//  ExchangeRateView.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 22/11/20.
//

import SwiftUI

struct ExchangeRateView: View {
    @Binding var amount: String
    @Binding var rate: Double
    
    var body: some View {
        VStack {
            HStack {
                Text("Exchange Rate")
                    .font(.system(size: ViewConstants.fontMedium, weight:
                                    .semibold))
                Spacer()
            }.padding(.vertical, ViewConstants.small)
            Button(action: {}) {
                HStack {
                    Spacer()
                    Text("\((Double(self.amount) ?? 0) * rate, specifier: "%.2f")")
                        .font(.system(size: ViewConstants.fontMedium, weight: .semibold))
                    Spacer()
                }
            }.buttonStyle(PrimaryButtonStyle(fillColor: .darkPrimaryButton))
        }.padding()
    }
}

struct ExchangeRateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExchangeRateView(amount: .constant("1"),
                             rate: .constant(10.0))
        }
        NavigationView {
            ExchangeRateView(amount: .constant("1"),
                             rate: .constant(10.0))
        }.environment(\.colorScheme, .dark)
    }
}
