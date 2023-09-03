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
