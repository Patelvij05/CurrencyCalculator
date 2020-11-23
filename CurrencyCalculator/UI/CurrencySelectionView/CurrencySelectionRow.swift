//
//  CurrencySelectionRow.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 20/11/20.
//

import SwiftUI

struct CurrencySelectionRow: View {
    
    var currency: String
    var fullName: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(currency)
                .font(.system(size: ViewConstants.fontMedium,
                              weight: .bold,
                              design: .monospaced)
                )
                .foregroundColor(Color.textPrimary)
            Spacer()
            Text(fullName)
                .font(.system(size: ViewConstants.fontSmall,
                              weight: .regular,
                              design: .monospaced)
                )
                .foregroundColor(Color.textMedium)
            
        }
        .contentShape(Rectangle())
    }
}

struct CurrencySelectionRow_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionRow(currency: "BaseCurrency".localized(), fullName: "BaseCurrencyFullName".localized())
            .previewLayout(.fixed(width: 400, height: 50))
    }
}
