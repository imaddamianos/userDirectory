//
//  Connection.swift
//  UserDirectory
//
//  Created by iMad on 02/09/2023.
//

import Foundation
import Network
import UIKit

let monitor = NWPathMonitor()

class Connection: NSObject {
    static let shared: Connection = Connection()

    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }

    func startConnMonitor(completion: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    completion(true) // Internet connection is available
                }
            } else {
                DispatchQueue.main.async {
                    completion(false) // No internet connection
                }
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}

func stopConnMonitor() {
    monitor.cancel()
}
