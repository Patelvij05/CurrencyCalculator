//
//  NetworkMonitor.swift
//  CurrencyCalculator
//
//  Created by Vijay Patel on 22/11/20.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {

    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")

    @Published var isConnected = true

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }

}
