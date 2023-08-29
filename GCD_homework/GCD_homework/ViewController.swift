import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var userTableView: UITableView!
    var users: [Users] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initUser()
        userTableView.dataSource = self
        userTableView.delegate = self
        userTableView.separatorInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        userTableView.register(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "UserListCell")
    }
    private func initUser() {
        users.append(Users(avtURL: "aido", userName: "User1", link: "Depzai.ui"))
        users.append(Users(avtURL: "aido", userName: "User1", link: "Depzai.ui"))
        users.append(Users(avtURL: "aido", userName: "User1", link: "Depzai.ui"))
        users.append(Users(avtURL: "aido", userName: "User1", link: "Depzai.ui"))
        users.append(Users(avtURL: "aido", userName: "User1", link: "Depzai.ui"))
    }
}
let userListCellIndentifier = "UserListCell"
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: userListCellIndentifier) as? UserListCell else {
            return UITableViewCell()
        }
        cell.setUser(user: users[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConfigCell.UserListCell.cellHigh
        }
}
