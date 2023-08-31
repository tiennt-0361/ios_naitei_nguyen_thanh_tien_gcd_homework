import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var userTableView: UITableView!
    var users: [Users] = []
    var viewUsers: [Users] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        userTableView.dataSource = self
        userTableView.delegate = self
        searchBar.delegate = self
        userTableView.separatorInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        userTableView.register(
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
                self.userTableView.reloadData()
            }
        }, failureHandler: {
            print("Error fetching API")
        })
    }
}
extension ViewController: UITableViewDataSource {
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

extension ViewController: UITableViewDelegate {
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
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewUsers = users
        } else {
            viewUsers = users.filter({ user in
                user.loginName.localizedCaseInsensitiveContains(searchText)
            })
        }
        userTableView.reloadData()
    }
}
