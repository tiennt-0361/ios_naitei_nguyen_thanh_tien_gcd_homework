import UIKit

final class DetailProfileViewController: UIViewController {
    @IBOutlet private weak var imgUser: UIImageView!
    @IBOutlet private weak var loginName: UILabel!
    @IBOutlet private weak var link: UILabel!
    @IBOutlet private weak var userTableView: UITableView!
    @IBOutlet private weak var userFollowView: UIView!
    @IBOutlet private weak var following: UILabel!
    @IBOutlet private weak var followers: UILabel!
    @IBOutlet private weak var repository: UILabel!
    @IBOutlet private weak var tableControl: UISegmentedControl!
    var userTarget: Users?
    private var viewUser: [Users] = []
    private var followerUser: [Users] = []
    private var followingUser: [Users] = []
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
        ApiManager.shared.getImg(url: user.avtUrl) { [weak self] image in
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
        let followingGetUrl = user.followingUrl.components(separatedBy: "{").first!
        let followerGetUrl = user.followersUrl
        let reposGetUrl = user.reposUrl
        ApiManager.shared.request(
            url: followerGetUrl,
            type: [Users].self,
            completionHandler: { [weak self] userList in
            self?.followerUser = userList
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.followers.text = "\(self.followerUser.count)"
                self.viewUser = self.followerUser
                self.userTableView.reloadData()
            }
        }, failureHandler: {
            print("Error fetching API")
        })
        ApiManager.shared.request(
            url: followingGetUrl,
            type: [Users].self,
            completionHandler: { [weak self] userList in
            self?.followingUser = userList
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.following.text = "\(self.followingUser.count)"
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
    }
    @IBAction func changedValueTableControl(_ sender: Any) {
        if tableControl.selectedSegmentIndex == 0 {
            viewUser = followerUser
        } else {
            viewUser = followingUser
        }
        userTableView.reloadData()
    }
}
extension DetailProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConfigCell.UserListCell.cellHigh
    }
}
extension DetailProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewUser.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constant.Value.userListCellIndentifier)
                as? UserListCell else {
            return UITableViewCell()
        }
        cell.setUser(user: viewUser[indexPath.row])
        return cell
    }
}
