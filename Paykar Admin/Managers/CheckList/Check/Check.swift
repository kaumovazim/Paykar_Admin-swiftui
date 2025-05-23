//
//  Check.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 29.03.2025.
//

import Foundation
import Alamofire

class CheckDate: ObservableObject {
    @Published var check: CheckModel?  // изменили тип на одиночный объект

    func fetchCheckStatus(completion: @escaping (Bool) -> Void) {
        if let adminData = UserManager.shared.retrieveUserFromStorage() {
            let url = "https://admin.paykar.tj/api/admin/check_list/check.php"
            let userId = adminData.id
            let parameters: [String: Int] = [
                "userId": userId
            ]
            AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: CheckModel.self) { response in
                    switch response.result {
                    case .success(let checkResponse):
                        DispatchQueue.main.async {
                            self.check = checkResponse
                            completion(true)
                        }
                    case .failure(let error):
                        print("Ошибка загрузки данных: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
        }
    }

}
