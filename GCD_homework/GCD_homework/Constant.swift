import UIKit
import Foundation
class Constant {
    struct Value {
        static let userListCellIndentifier = "UserListCell"
        static let unibListUserCellName = "UserListCell"
        static let DetailProfileSceneIndentifier = "DetailProfileScenes"
    }
    struct DetailValue {
        static let detailImageRadius: CGFloat = 90
        static let detailFollowViewRadius: CGFloat = 10
    }
    struct BaseUrl {
        static let getUserBaseUrl = "https://api.github.com"
    }
    struct Endpoint {
        static let getUserEndpoint = "search"
    }
    struct Query {
        static let getUserQuery = "users?q=abc"
    }
}
