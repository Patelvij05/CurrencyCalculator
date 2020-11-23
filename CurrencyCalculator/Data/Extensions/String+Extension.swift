//
//  String+Extension.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 22/11/20.
//

import SwiftUI

extension String{
    // MARK: Substring JPY from USDJPY
    func trimmed() -> String{
        let start = self.index(self.startIndex, offsetBy: 3)
        let end = self.endIndex
        let range = start..<end
        return String(self[range])
    }
    
    func localized(withComment comment: String? = nil) -> String {
        NSLocalizedString(self, comment: comment ?? "")
    }
}
