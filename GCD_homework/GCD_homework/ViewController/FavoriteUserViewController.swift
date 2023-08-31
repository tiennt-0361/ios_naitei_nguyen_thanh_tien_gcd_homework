import UIKit

final class FavoriteUserViewController: UIViewController {
    @IBOutlet weak var tableViewUsers: UITableView!
    var users: [Users] = []
    var viewUsers: [Users] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        tableViewUsers.delegate = self
        tableViewUsers.dataSource = self
        tableViewUsers.separatorInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        tableViewUsers.register(
            UINib(nibName: Constant.Value.unibListUserCellName,
                  bundle: nil),
            forCellReuseIdentifier: Constant.Value.userListCellIndentifier)
    }
    private func fetchUser() {
        let url = Constant.BaseUrl.getUserBaseUrl + "/"
            + Constant.Endpoint.getUserEndpoint + "/"
            + Constant.Query.getUserQuery
        ApiManager.shared.request(url: url, type: UserList.self, completionHandler: { [weak self] userList in
            self?.users = userList.items
            self?.viewUsers = userList.items
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableViewUsers.reloadData()
            }
        }, failureHandler: {
            print("Error fetching API")
        })
    }
}
extension FavoriteUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return ConfigCell.UserListCell.cellHigh
    }
}
extension FavoriteUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constant.Value.userListCellIndentifier)
                as? UserListCell else {
            return UITableViewCell()
        }
        cell.setUser(user: viewUsers[indexPath.row])
        return cell
    }
}
