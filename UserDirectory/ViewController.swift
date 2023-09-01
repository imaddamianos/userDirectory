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
        
        // Add the activity indicator as a subview
        view.addSubview(activityIndicator)
        
        // Center the activity indicator in the view
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Fetch users from the API and populate the usersArray
        activityIndicator.startAnimating()
        fetchUsers { [weak self] (users, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }
            
            if let users = users {
                cacheUsers(users)
                usersArray = users
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    self?.usersTbl.reloadData()
                }
            }
        }
    }
    
    func setupView(){
        usersTbl.dataSource = self
        usersTbl.delegate = self
        usersTbl.register(UsersTableViewCell.nib, forCellReuseIdentifier: UsersTableViewCell.identifier)
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
                    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
    }
}


// MARK: - UITableViewDataSource - UITableViewDataSource

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140 // Adjust the height to your desired value
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else {
            fatalError("Failed to dequeue a reusable cell.")
        }
        
        // Get the user data for the current row
        let user = usersArray[indexPath.row]
        
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


