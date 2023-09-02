//
//  Indicator.swift
//  UserDirectory
//
//  Created by iMad on 02/09/2023.
//

import Foundation
import UIKit

// Create an instance of UIActivityIndicatorView
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()


//extension UIViewController {
//    
//    func addKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    @objc private func keyboardWillHide(_ notification: Notification) {
//        UIView.animate(withDuration: 0.3) {
//            self.view.transform = .identity
//        }
//        self.view.layoutIfNeeded()
//    }
//    
//    func setupKeyboardDismissRecognizer() {
//        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapRecognizer)
//    }
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//
//}
