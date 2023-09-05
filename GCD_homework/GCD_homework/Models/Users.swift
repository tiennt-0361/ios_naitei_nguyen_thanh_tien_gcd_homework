import Foundation
struct Users: Decodable {
    let avtUrl: String?
    let loginName: String?
    let link: String?
    let followersUrl: String?
    let followingUrl: String?
    let reposUrl: String?
    enum CodingKeys: String, CodingKey {
        case avtUrl = "avatar_url"
        case loginName = "login"
        case link = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case reposUrl = "repos_url"
    }
    init(_ favouriteUser: FavoriteUser) {
        avtUrl = favouriteUser.avtImgUrl
        loginName = favouriteUser.loginName
        link = favouriteUser.githubLink
        followersUrl = favouriteUser.followerUrl
        followingUrl = favouriteUser.followingUrl
        reposUrl = favouriteUser.reposUrl
    }
}
