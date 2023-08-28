//
//  UserListCell.swift
//  GCD_homework
//
//  Created by Thanh Duong on 28/08/2023.
//

import UIKit

final class UserListCell: UITableViewCell {

   
    @IBOutlet private weak var background: UIView!
    @IBOutlet private weak var userimg: UIImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var userLink: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func config(){
        background.clipsToBounds = false
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOffset = ConfigCell.UserListCell.shadowOffsetBackgroundTableView
        background.layer.shadowOpacity = ConfigCell.UserListCell.shadowOpacityBackground
        background.layer.cornerRadius = ConfigCell.UserListCell.cornerRadiusBackground
        background.layer.shadowRadius = ConfigCell.UserListCell.shadowRadiusBackgroundTableView
        userimg.layer.cornerRadius = ConfigCell.UserListCell.cornerRadiusImage
    }
    func setUser(user: Users){
        userimg.image = UIImage(named: user.avtURL)
        userName.text = user.userName
        userLink.text = user.link
    }
}
