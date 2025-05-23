////
////  Createnews.swift
////  Paykar Admin
////
////  Created by Macbook Pro on 01.04.2025.
////
import Foundation
import Alamofire
import Foundation
import Alamofire

class CreateNews: ObservableObject {
    @Published var isLoading = false

    func create(titel: String, discription: String, imageData: Data?, link: String, completion: @escaping (NewsCreateResponse) -> Void) {
        isLoading = true

        let createNewsURL = "https://admin.paykar.tj/api/admin/news/create.php"
        let uploadImageURL = "https://admin.paykar.tj/api/admin/news/upload.php"
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        // Получение userId
        guard let adminData = UserManager.shared.retrieveUserFromStorage() else {
            handleError(error: "User not authenticated", completion: completion)
            return
        }
        let userId = adminData.id

        // Если изображение предоставлено, загружаем его
        if let imageData = imageData {
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
            }, to: uploadImageURL, headers: headers)
            .responseDecodable(of: UploadImageResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let uploadResponse):
                        if response.response?.statusCode == 200, let imageName = uploadResponse.imageName {
                            // Формирование параметров с именем загруженного изображения
                            let parameters = NewsModel(
                                title: titel,
                                description: discription,
                                image: imageName,
                                link: link,
                                publishedUserId: userId
                            )
                            self.createNews(with: parameters, url: createNewsURL, completion: completion)
                        } else {
                            self.handleError(error: "Upload failed: Invalid response", completion: completion)
                        }
                    case .failure(let error):
                        self.handleError(error: "Upload failed: \(error.localizedDescription)", completion: completion)
                    }
                }
            }
        } else {
            // Если изображения нет, создаем новость без поля image
            let parameters = NewsModel(
                title: titel,
                description: discription,
                image: "", // Или nil, если API поддерживает отсутствие поля
                link: link,
                publishedUserId: userId
            )
            self.createNews(with: parameters, url: createNewsURL, completion: completion)
        }
    }

    // Вспомогательный метод для создания новости
    private func createNews(with parameters: NewsModel, url: String, completion: @escaping (NewsCreateResponse) -> Void) {
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: NewsCreateResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let createResponse):
                        if response.response?.statusCode == 200 {
                            completion(createResponse)
                        } else {
                            self.handleError(error: "Create failed: Invalid response", completion: completion)
                        }
                    case .failure(let error):
                        self.handleError(error: "Create failed: \(error.localizedDescription)", completion: completion)
                    }
                }
            }
    }

    // Вспомогательная функция для обработки ошибок
    private func handleError(error: String, completion: @escaping (NewsCreateResponse) -> Void) {
        self.isLoading = false
        print(error)
        completion(NewsCreateResponse(status: "error", message: error))
    }
}
