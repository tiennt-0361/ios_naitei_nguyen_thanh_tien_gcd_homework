import UIKit
import CoreData

final class FavoriteUserViewController: UIViewController {
    @IBOutlet private weak var tableViewUsers: UITableView!
    private var database = DatabaseManager()
    private var favoriteUsers: [FavoriteUser] = []
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
    override func viewWillAppear(_ animated: Bool) {
        fetchUser()
    }
    private func fetchUser() {
        do {
            favoriteUsers = try database.context.fetch(database.fetchRequest)
        } catch {
            print("Error fetching data \(error)")
        }
        tableViewUsers.reloadData()
    }
}
extension FavoriteUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return ConfigCell.UserListCell.cellHigh
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let detailUser = storyboard?.instantiateViewController(
            withIdentifier: Constant.Value.DetailProfileSceneIndentifier) as? DetailProfileViewController {
            let user = Users(favoriteUsers[indexPath.row])
            detailUser.setUser(user: user)
            self.navigationController?.pushViewController(detailUser, animated: true)
        }
    }
}
extension FavoriteUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constant.Value.userListCellIndentifier)
                as? UserListCell else {
            return UITableViewCell()
        }
        cell.setUser(user: Users.init(favoriteUsers[indexPath.row]))
        return cell
    }
}
