//
//  UserDetails.swift
//  UserDirectory
//
//  Created by iMad on 01/09/2023.
//

import Foundation

import Foundation

var usersArray: [UserSruct] = []

struct Results: Codable {
    let results: [UserSruct]
}

struct UserSruct: Codable {
    var name: Name
    var email: String
    let picture: Picture
    var phone: String
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
