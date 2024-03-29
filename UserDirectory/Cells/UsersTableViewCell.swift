//
//  UsersTableViewCell.swift
//  UserDirectory
//
//  Created by iMad on 01/09/2023.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }


    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var mobileNbLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        userImg.layer.cornerRadius = userImg.frame.size.width / 2
        userImg.clipsToBounds = true
        viewCell.layer.borderWidth = 1
        viewCell.layer.cornerRadius = 10
        viewCell.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
