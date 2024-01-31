//
//  ConnectivityManager.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/31/24.
//

import Foundation
import UIKit
import Network

enum ConnectionStatus {
    case Connected
    case Disconnected
    
    var message: String {
        switch self {
        case .Connected:
            return "Online"
        case .Disconnected:
            return "Offline"
        }
    }
    
    var statusColor: UIColor {
        switch self {
        case .Connected:
            return UIColor.green
        case .Disconnected:
            return UIColor.red
        }
    }
}

class ConnectivityManager {
    // create as a singleton
    static let shared = ConnectivityManager()
    
    private var monitor: NWPathMonitor
    
    private let queue = DispatchQueue.global(qos: .background)
    
    private var isMonitoring: Bool = false
    
    // use to check if network is connected
    public private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        if isMonitoring {
            return
        }
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isConnected = true
            } else {
                self?.isConnected = false
            }
        }
        isMonitoring = true
    }
    
    func stopMonitoring() {
        if isMonitoring {
            self.monitor.cancel()
            self.isMonitoring = false
        }
    }
    
    deinit {
        stopMonitoring()
    }
}
