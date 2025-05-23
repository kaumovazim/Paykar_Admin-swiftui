//
//  UsersByPositionUnit.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 03.04.2025.
//

import Foundation
import Alamofire

class GetUsersSelection: ObservableObject {
    @Published var users: [UserByUnitPositionModel] = []
    @Published var isLoading: Bool = false
    
    func getUsers(unit: String, position: String, completion: @escaping ([UserByUnitPositionModel]) -> Void = { _ in }) {
        isLoading = true
        let url = "https://admin.paykar.tj/api/visitsreports/users_by_positions.php"
        let parameters: [String: String] = [
            "unit": unit,
            "position": position
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [UserByUnitPositionModel].self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let userNames):
                        self.users = userNames
                        completion(userNames)
                    case .failure(let error):
                        print("Ошибка загрузки пользователей: \(error)") // Отладка
                        self.users = []
                        completion([])
                    }
                }
            }
    }
}

