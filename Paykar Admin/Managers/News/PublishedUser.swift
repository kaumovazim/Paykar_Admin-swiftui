//
//  PublishedUser.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 23.04.2025.
//

import Alamofire
import Foundation

class GetPublishedUser: ObservableObject {
    @Published var user: PublishedUserResponseModel? // Храним только одного пользователя

    func fetchUserById(userId: String, completion: @escaping (PublishedUserResponseModel?) -> Void) {
        let url = "https://admin.paykar.tj/api/admin/adminUser/usersById.php"
        let params = PublishedUserRequestBody(userId: userId)

 
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: PublishedUserResponseModel.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let user):
                        self.user = user // Сохраняем пользователя
                        completion(user)
                    case .failure(let error):
                        self.user = nil
                        completion(nil)
                    }
                }
            }
    }
}
