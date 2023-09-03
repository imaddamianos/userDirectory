//
//  UserAPI.swift
//  UserDirectory
//
//  Created by iMad on 01/09/2023.
//

import Foundation

func fetchUsers(page: Int, completion: @escaping ([UserSruct]?, Error?) -> Void) {
    let url = URL(string: "https://randomuser.me/api/?page=\(page)&results=20")!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Results.self, from: data)
                let encryptedUsers = result.results.map { user in
                    return encryptUser(user)
                }
                completion(encryptedUsers, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    task.resume()
}

func cacheUsers(_ users: [UserSruct]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(users) {
        UserDefaults.standard.set(encoded, forKey: "cachedUsers")
    }
}

func loadCachedUsers() -> [UserSruct]? {
    if let data = UserDefaults.standard.data(forKey: "cachedUsers"),
       let users = try? JSONDecoder().decode([UserSruct].self, from: data) {
        return users
    }
    return nil
}

func encryptUser(_ user: UserSruct) -> UserSruct {
    var encryptedUser = user
    //encrypt individual components
    encryptedUser.name.title = xorEncrypt(user.name.title)
    encryptedUser.name.first = xorEncrypt(user.name.first)
    encryptedUser.name.last = xorEncrypt(user.name.last)
    encryptedUser.email = xorEncrypt(user.email)
    encryptedUser.phone = xorEncrypt(user.phone)
    
    return encryptedUser
}

func xorEncrypt(_ input: String) -> String {
    let key: UInt8 = 0x5A  // XOR key
    var result = ""
    for char in input.utf8 {
        let encryptedChar = char ^ key
        result.append(String(UnicodeScalar(encryptedChar)))
    }
    return result
}

func xorDecrypt(_ input: String) -> String {
    let key: UInt8 = 0x5A  // XOR key
    var result = ""
    for char in input.utf8 {
        let decryptedChar = char ^ key
        result.append(String(UnicodeScalar(decryptedChar)))
    }
    return result
}
