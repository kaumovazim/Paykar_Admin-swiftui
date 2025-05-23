import Foundation
// MARK: - Models
struct NewsListResponseModel: Codable {
    let status: String?
    let newsDats: [NewsListModel]?
}

struct NewsListModel: Codable, Identifiable, Equatable {
    let id: String
    let create_date: String
    let title: String?
    let description: String?
    let image: String?
    let link: String?
    let published_user_id: String?

}
