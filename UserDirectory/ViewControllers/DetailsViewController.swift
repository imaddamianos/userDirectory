//
//  DetailsViewController.swift
//  UserDirectory
//
//  Created by iMad on 02/09/2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var user: UserSruct?

    @IBOutlet weak var detailsImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if user data is available
         if let user = user {
             nameLbl.text = "\(xorDecrypt(user.name.first)) \(xorDecrypt(user.name.last))"
             emailLbl.text = xorDecrypt(user.email)
             mobileLbl.text = xorDecrypt(user.phone)
             genderLbl.text = xorDecrypt(user.gender)
             
             // Load the user's profile picture asynchronously
             if let imageURL = URL(string: user.picture.large) {
                 URLSession.shared.dataTask(with: imageURL) { [weak self] (data, _, _) in
                     if let data = data, let image = UIImage(data: data) {
                         DispatchQueue.main.async {
                             self?.detailsImg.image = image
                         }
                     }
                 }.resume()
             }
         }
    }
    
}
