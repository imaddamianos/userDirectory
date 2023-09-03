//
//  ViewController.swift
//  UserDirectory
//
//  Created by iMad on 01/09/2023.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var usersTbl: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var genderPercentage: UILabel!
    @IBOutlet weak var themeLbl: UILabel!
    var isFetchingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchUsers()
    }
    
    func setupView(){
        searchBar.delegate = self
        usersTbl.dataSource = self
        usersTbl.delegate = self
        usersTbl.register(UsersTableViewCell.nib, forCellReuseIdentifier: UsersTableViewCell.identifier)
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
        Connection.shared.startMonitoring()
        themeSwitch.addTarget(self, action: #selector(themeSwitchChanged(_:)), for: .valueChanged)
        checkTheme()
       
    }
    
    func filterUsers(with searchText: String) {
        if searchText.isEmpty {
            // If the search text is empty, show all users
            filteredUsers = usersArray
        } else {
            // Filter users based on the search text
            filteredUsers = usersArray.filter { user in
                let searchTextLowercased = searchText.lowercased()
                let fullName = "\(xorDecrypt(user.name.title)) \(xorDecrypt(user.name.first)) \(xorDecrypt(user.name.last)) \(xorDecrypt(user.email)) \(xorDecrypt(user.phone))".lowercased()
                
                return fullName.contains(searchTextLowercased)
            }
        }
        usersTbl.reloadData()
    }
    
    func fetchUsers() {
        UserDirectory.fetchUsers(page: currentPage) { [weak self] (users, error) in
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
                    self?.calculateGenderPercentage()
                    self?.usersTbl.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let indexPath = usersTbl.indexPathForSelectedRow {
                let selectedUser = filteredUsers[indexPath.row]
                if let detailsViewController = segue.destination as? DetailsViewController {
                    detailsViewController.user = selectedUser
                }
            }
        }
    }
    
    @objc func themeSwitchChanged(_ sender: UISwitch) {
            if sender.isOn {
                // Switch is ON (Dark Mode)
                overrideUserInterfaceStyle = .dark
                view.backgroundColor = AppTheme.darkModeBackgroundColor
            } else {
                // Switch is OFF (Light Mode)
                overrideUserInterfaceStyle = .light
                view.backgroundColor = AppTheme.lightModeBackgroundColor
            }
        checkTheme()
        }
    
    func checkTheme(){
        let currentTraitCollection = self.traitCollection
        let currentTheme: UIUserInterfaceStyle = currentTraitCollection.userInterfaceStyle

                if currentTheme == .light {
                    themeLbl.text = "Light"
                } else if currentTheme == .dark {
                    themeLbl.text = "Dark"
                }
    }
    func calculateGenderPercentage() {
            // Calculate the percentage of males and females
            let totalUsers = filteredUsers.count
            let malesCount = filteredUsers.filter { $0.gender == "male" }.count
            let femalesCount = filteredUsers.filter { $0.gender == "female" }.count
            
            let malesPercentage = (Double(malesCount) / Double(totalUsers)) * 100.0
            let femalesPercentage = (Double(femalesCount) / Double(totalUsers)) * 100.0
            
            // Update the label text with the calculated percentages
        genderPercentage.text = "M: \(Int(malesPercentage))% | F: \(Int(femalesPercentage))%"
        }
}

// MARK: - UIScrollView
extension ViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.height

        // Check if the user has scrolled to the bottom
        if offsetY > contentHeight - screenHeight - 100 {
            if !isLoadingMore && !isFetchingData {
                activityIndicator.startAnimating()
                isFetchingData = true // Set the flag to indicate a fetch request is in progress
                currentPage += 1
                UserDirectory.fetchUsers(page: currentPage) { [weak self] (users, error) in
                    if let error = error {
                        print("Error fetching more users: \(error)")
                    }

                    if let users = users {
                        filteredUsers.append(contentsOf: users)
                        DispatchQueue.main.async {
                            self?.usersTbl.reloadData()
                            activityIndicator.stopAnimating()
                            self?.calculateGenderPercentage()
                            isLoadingMore = false
                            self?.isFetchingData = false // Reset the flag when the request completes
                        }
                    }
                }
            }
        }
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
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else {
            fatalError("Failed to dequeue a reusable cell.")
        }
        let user = filteredUsers[indexPath.row]
        
        // Configure the cell with user data
        cell.emailLbl.text = xorDecrypt(user.email)
        cell.mobileNbLbl.text = xorDecrypt(user.phone)
        cell.userNameLbl.text = "\(xorDecrypt(user.name.title)) \(xorDecrypt(user.name.first)) \(xorDecrypt(user.name.last))"
        if let imageURL = URL(string: user.picture.medium) {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetails", sender: self)
    }
    
}


