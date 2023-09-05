import Foundation
import UIKit
import CoreData
class DatabaseManager {
    static let database = DatabaseManager()
    var fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
    var context = CoreDataManager.shared.persistentContainer.viewContext
    func fetch() -> [FavoriteUser] {
        var favoriteUsers: [FavoriteUser] = []
        do {
            let fetchFavoriteUsers = try context.fetch(fetchRequest) as [FavoriteUser]?
            if let fetchFavoriteUsers = fetchFavoriteUsers {
                favoriteUsers = fetchFavoriteUsers
            }
        } catch {
            print("Fetch Data from coredata Error")
        }
        return favoriteUsers
    }
    func checkFavorite(userTarget: Users) -> FavoriteUser? {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        do {
            let favouriteUsers = try context.fetch(fetchRequest)
            guard let favoriteUser = favouriteUsers
                    .filter({($0 as AnyObject).loginName == userTarget.loginName})
                    .first else { return nil}
            return favoriteUser
        } catch {
            print("Error fetching data \(error)")
            return nil
        }
    }
}
