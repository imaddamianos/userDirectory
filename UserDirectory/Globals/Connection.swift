//
//  Connection.swift
//  UserDirectory
//
//  Created by iMad on 02/09/2023.
//

import Foundation
import Network
import UIKit

class Connection {
    static let shared = Connection()
    
    private let monitor = NWPathMonitor()
    
    var isMonitoring = false
    
    private init() {}
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("Network is available")
            } else {
                DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    self?.showAlert(title: "Network Error", message: "Check your internet connection", viewController: rootViewController)
                }
                }
                print("Network is not available")
                
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring else { return }
        monitor.cancel()
        isMonitoring = false
    }
    
    func showAlert(title: String, message: String, viewController: UIViewController?) {
        if let viewController = viewController {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
