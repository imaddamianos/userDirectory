//
//  UserDetails.swift
//  UserDirectory
//
//  Created by iMad on 01/09/2023.
//

import Foundation
import UIKit

var currentPage = 1
var usersArray: [UserSruct] = []
var isLoadingMore = false // To prevent multiple requests while loading
var filteredUsers: [UserSruct] = []
var isSearching = false

struct Results: Codable {
    let results: [UserSruct]
}

struct UserSruct: Codable {
    var name: Name
    var email: String
    let picture: Picture
    var phone: String
    var gender: String
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct Name: Codable {
    var title: String
    var first: String
    var last: String
}

struct AppTheme {
    static let lightModeBackgroundColor = UIColor.white
    static let darkModeBackgroundColor = UIColor.black
}
