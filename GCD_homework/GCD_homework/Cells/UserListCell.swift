import UIKit

final class UserListCell: UITableViewCell {
    @IBOutlet private weak var background: UIView!
    @IBOutlet private weak var imgUser: UIImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var userLink: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func config() {
        background.clipsToBounds = false
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOffset = ConfigCell.UserListCell.shadowOffsetBackgroundTableView
        background.layer.shadowOpacity = ConfigCell.UserListCell.shadowOpacityBackground
        background.layer.cornerRadius = ConfigCell.UserListCell.cornerRadiusBackground
        background.layer.shadowRadius = ConfigCell.UserListCell.shadowRadiusBackgroundTableView
        imgUser.layer.cornerRadius = ConfigCell.UserListCell.cornerRadiusImage
    }
    func setUser(user: Users) {
        guard let avtUrl = user.avtUrl else {return }
        ApiManager.shared.getImg(url: avtUrl) { [weak self] image in
            guard let self = self else { return }
            self.imgUser.image = image
        }
        userName.text = user.loginName
        userLink.text = user.link
    }
}
