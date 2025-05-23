//
//  PositionList.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 03.04.2025.
//

import Foundation
import Alamofire

class PositionList: ObservableObject {
@Published var positions: [PositionListModel] = []
@Published var isLoading: Bool = false

func getPositionList(unit: String, completion: @escaping ([PositionListModel]) -> Void = { _ in }) {
    isLoading = true
    let url = "https://admin.paykar.tj/api/visitsreports/list_position.php"
    let parameters: [String: String] = ["unit": unit]
    
    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        .validate()
        .responseDecodable(of: [PositionListModel].self) { response in
            DispatchQueue.main.async {
                self.isLoading = false
                switch response.result {
                case .success(let positionNames):
                    self.positions = positionNames
                    completion(positionNames)
                case .failure(let error):
                    print("Ошибка загрузки позиций: \(error)") // Отладка
                    self.positions = [] // Очищаем список в случае ошибки
                    completion([])
                }
            }
        }
}
}
