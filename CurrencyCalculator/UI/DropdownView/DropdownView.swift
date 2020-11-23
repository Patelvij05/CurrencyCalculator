//
//  DropdownView.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 20/11/20.
//

import SwiftUI

struct DropdownView: View {
    
    @Binding var currency: String
    @Binding var showCurrencySelection: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Select Currency")
                    .font(.system(size: ViewConstants.fontMedium, weight:
                                    .semibold))
                Spacer()
            }.padding(.vertical, ViewConstants.small)
            Button(action: {
                self.showCurrencySelection.toggle()
            }) {
                HStack {
                    Text(currency)
                        .font(.system(size: ViewConstants.fontMedium, weight: .semibold))
                    Spacer()
                    Image(systemName: "arrowtriangle.down.circle")
                        .font(.system(size: ViewConstants.fontMedium, weight: .medium))
                }
            }.buttonStyle(PrimaryButtonStyle(fillColor: .darkPrimaryButton))
        }.padding()
    }
}

struct DropdownView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DropdownView(currency: .constant("USD"),
                showCurrencySelection: .constant(false))
        }
        NavigationView {
            DropdownView(currency: .constant("USD"),
                showCurrencySelection: .constant(false))
        }.environment(\.colorScheme, .dark)
    }
}
