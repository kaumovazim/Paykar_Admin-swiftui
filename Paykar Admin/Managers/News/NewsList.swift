import Foundation
import Alamofire

class NewsListViewModel: ObservableObject {
    @Published var displayedNews: [NewsListModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var allNews: [NewsListModel] = []
    private let baseImageURL = "https://admin.paykar.tj/upload/news/media/"
    private let pageSize = 10
    private var currentPage = 0

    func fetchNews(isInitial: Bool = true) {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        if isInitial {
            currentPage = 0
            allNews.removeAll()
            displayedNews.removeAll()
        }

        let url = "https://admin.paykar.tj/api/admin/news/list.php"
        AF.request(url).validate().responseDecodable(of: NewsListResponseModel.self) { response in
            DispatchQueue.main.async {
                self.isLoading = false
                switch response.result {
                case .success(let responseModel):
                    if let news = responseModel.newsDats {
                        if isInitial {
                            self.allNews = news
                            let nextBatch = Array(news.prefix(self.pageSize))
                            self.displayedNews = nextBatch
                            self.currentPage = 1
                        }
                    } else {
                        self.errorMessage = "No news data received"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadMoreNews() {
        let startIndex = currentPage * pageSize
        let endIndex = min(startIndex + pageSize, allNews.count)
        if startIndex < allNews.count {
            let nextBatch = Array(allNews[startIndex..<endIndex])
            displayedNews.append(contentsOf: nextBatch)
            currentPage += 1
        }
    }

    func hasMoreNews() -> Bool {
        return displayedNews.count < allNews.count
    }

    func imageURL(for image: String?) -> URL? {
        guard let image = image else { return nil }
        return URL(string: baseImageURL + image)
    }
}
