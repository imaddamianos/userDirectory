//
//  ViewController.swift
//  UserDirectory
//
//  Created by iMad on 01/09/2023.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var usersTbl: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        // Fetch users from the API and populate the usersArray
        fetchUsers { [weak self] (users, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }
            
            if let users = users {
                cacheUsers(users)
                usersArray = users
                filteredUsers = usersArray
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    self?.usersTbl.reloadData()
                }
            }
        }
    }
    
    func setupView(){
        searchBar.delegate = self
        usersTbl.dataSource = self
        usersTbl.delegate = self
        usersTbl.register(UsersTableViewCell.nib, forCellReuseIdentifier: UsersTableViewCell.identifier)
        // Add the activity indicator
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func filterUsers(with searchText: String) {
        if searchText.isEmpty {
            // If the search text is empty, show all users
            filteredUsers = usersArray
        } else {
            // Filter users based on the search text
            filteredUsers = usersArray.filter { user in
                let searchTextLowercased = searchText.lowercased()
                let fullName = "\(xorDecrypt(user.name.first)) \(xorDecrypt(user.name.last)) \(xorDecrypt(user.email))".lowercased()
                
                return fullName.contains(searchTextLowercased) || xorDecrypt(user.phone).contains(searchText)
            }
        }
        
        // Reload the table view to display the filtered results
        usersTbl.reloadData()
    }

}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // Update the filtered users based on the search text
            filterUsers(with: searchText)
            isSearching = !searchText.isEmpty
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // Clear the search bar and show all users when the cancel button is clicked
            searchBar.text = ""
            filterUsers(with: "")
            searchBar.resignFirstResponder()
            isSearching = false
        }
    
}

// MARK: - UITableViewDataSource - UITableViewDataSource

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140 // Adjust the height to your desired value
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else {
            fatalError("Failed to dequeue a reusable cell.")
        }
        
        // Get the user data for the current row
        let user = filteredUsers[indexPath.row]
        
        // Configure the cell with user data
        cell.emailLbl.text = xorDecrypt(user.email)
        cell.mobileNbLbl.text = xorDecrypt(user.phone)
        cell.userNameLbl.text = "\(xorDecrypt(user.name.title)) \(xorDecrypt(user.name.first)) \(xorDecrypt(user.name.last))"
        
        // Load the user image asynchronously
        if let imageURL = URL(string: user.picture.thumbnail) {
            URLSession.shared.dataTask(with: imageURL) { (data, _, _) in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.userImg.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        return cell
    }
}


