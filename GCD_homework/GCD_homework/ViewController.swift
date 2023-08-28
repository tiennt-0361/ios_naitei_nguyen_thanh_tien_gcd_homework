//
//  ViewController.swift
//  GCD_homework
//
//  Created by Thanh Duong on 28/08/2023.
//

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
    private func initUser(){
        users.append(Users(avtURL: "Aido", userName: "User1", link: "Depzai.ui"))
        users.append(Users(avtURL: "Aido", userName: "User1", link: "Depzai.ui"))
        users.append(Users(avtURL: "Aido", userName: "User1", link: "Depzai.ui"))
        users.append(Users(avtURL: "Aido", userName: "User1", link: "Depzai.ui"))
        users.append(Users(avtURL: "Aido", userName: "User1", link: "Depzai.ui"))
    }
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"UserListCell") as? UserListCell else {
            return UITableViewCell()
        }
        cell.setUser(user: users[indexPath.row])
        return cell
    }
}
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100 // Chiều cao của mỗi cell
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 10 // Chiều cao của header section, tạo khoảng cách giữa các cell
        }

        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 10 // Chiều cao của footer section, tạo khoảng cách giữa các cell
        }
}

