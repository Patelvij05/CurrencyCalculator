//
//  CurrencyCalculatorApp.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 19/11/20.
//

import SwiftUI

@main
struct CurrencyCalculatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CurrencyList()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
