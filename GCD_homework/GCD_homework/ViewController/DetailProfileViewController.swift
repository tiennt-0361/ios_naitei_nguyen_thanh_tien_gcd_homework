import UIKit
final class DetailProfileViewController: UIViewController {
    @IBOutlet private weak var favoriteBtn: UIButton!
    @IBOutlet private weak var imgUser: UIImageView!
    @IBOutlet private weak var loginName: UILabel!
    @IBOutlet private weak var link: UILabel!
    @IBOutlet private weak var userTableView: UITableView!
    @IBOutlet private weak var userFollowView: UIView!
    @IBOutlet private weak var following: UILabel!
    @IBOutlet private weak var followers: UILabel!
    @IBOutlet private weak var repository: UILabel!
    @IBOutlet private weak var tableControl: UISegmentedControl!
    private let database = DatabaseManager()
    private var userTarget: Users?
    private var viewUsers: [Users] = []
    private var followerUsers: [Users] = []
    private var followingUsers: [Users] = []
    private var favoriteUser: FavoriteUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFollow()
        config()
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.separatorInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        userTableView.register(
            UINib(nibName: Constant.Value.unibListUserCellName,
                  bundle: nil),
            forCellReuseIdentifier: Constant.Value.userListCellIndentifier)
    }
    private func config() {
        guard let user = userTarget else { return }
        guard let avtUrl = user.avtUrl else { return }
        ApiManager.shared.getImg(url: avtUrl) { [weak self] image in
            guard let self = self else { return }
            self.imgUser.image = image
        }
        imgUser.layer.cornerRadius = Constant.DetailValue.detailImageRadius
        userFollowView.layer.cornerRadius = Constant.DetailValue.detailFollowViewRadius
        loginName.text = user.loginName
        link.text = user.link
    }
    private func fetchFollow() {
        guard let user = userTarget else { return }
        guard let followingUrl = user.followingUrl else { return }
        guard let reposGetUrl = user.reposUrl else { return }
        let followingGetUrl = followingUrl.components(separatedBy: "{").first!
        guard let followerGetUrl = user.followersUrl else { return }
        ApiManager.shared.request(
            url: followerGetUrl,
            type: [Users].self,
            completionHandler: { [weak self] userList in
            self?.followerUsers = userList
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.followers.text = "\(self.followerUsers.count)"
                self.viewUsers = self.followerUsers
                self.userTableView.reloadData()
            }
        }, failureHandler: {
            print("Error fetching API")
        })
        ApiManager.shared.request(
            url: followingGetUrl,
            type: [Users].self,
            completionHandler: { [weak self] userList in
            self?.followingUsers = userList
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.following.text = "\(self.followingUsers.count)"
            }
        }, failureHandler: {
            print("Error fetching API")
        })
        ApiManager.shared.request(
            url: reposGetUrl,
            type: [Repository].self,
            completionHandler: { [weak self] repoList in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.repository.text = "\(repoList.count)"
            }
        }, failureHandler: {
            print("Error fetching API")
        })
        favoriteUser = database.checkFavorite(userTarget: user)
        if favoriteUser != nil {
            updateFavouriteButton()
        }
    }
    private func updateFavouriteButton() {
        if favoriteUser != nil {
            favoriteBtn.setImage(UIImage(systemName: Constant.FavoriteButton.fill), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(systemName: Constant.FavoriteButton.notFill), for: .normal)
        }
    }
    func setUser(user: Users) {
        self.userTarget = user
    }
    @IBAction private func favoriteBtnTouchUp(_ sender: Any) {
        guard let user = userTarget else { return }
        if let favouriteUser = favoriteUser {
            database.context.delete(favouriteUser)
            self.favoriteUser = nil
        } else {
            favoriteUser = FavoriteUser(context: database.context)
            favoriteUser?.githubLink = user.link
            favoriteUser?.loginName = user.loginName
            favoriteUser?.avtImgUrl = user.avtUrl
            favoriteUser?.followerUrl = user.followersUrl
            favoriteUser?.followingUrl = user.followersUrl
            favoriteUser?.reposUrl = user.reposUrl
        }
        try? database.context.save()
        updateFavouriteButton()
    }
    @IBAction private func changedValueTableControl(_ sender: Any) {
        if tableControl.selectedSegmentIndex == 0 {
            viewUsers = followerUsers
        } else {
            viewUsers = followingUsers
        }
        userTableView.reloadData()
    }
}
extension DetailProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConfigCell.UserListCell.cellHigh
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let detailUser = storyboard?.instantiateViewController(
            withIdentifier: Constant.Value.DetailProfileSceneIndentifier) as? DetailProfileViewController {
            detailUser.userTarget = viewUsers[indexPath.row]
            self.navigationController?.pushViewController(detailUser, animated: true)
        }
    }
}
extension DetailProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constant.Value.userListCellIndentifier)
                as? UserListCell else { return UITableViewCell() }
        cell.setUser(user: viewUsers[indexPath.row])
        return cell
    }
}
