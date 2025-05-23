//
//  UnitList.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 03.04.2025.
//

import Foundation
import Alamofire

class UnitList: ObservableObject {
    @Published var units: [UnitListModel] = [] // Переименовал name в units для ясности
    @Published var isLoading: Bool = false
    
    func getUnitName(completion: @escaping ([UnitListModel]) -> Void = { _ in }) {
        isLoading = true
        let url = "https://admin.paykar.tj/api/visitsreports/list_unit.php"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: [UnitListModel].self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let unitNames):
                        self.units = unitNames
                        completion(unitNames) // Вызываем completion с результатом
                    case .failure(let error):
                        print("Ошибка: \(error)")
                        completion([]) // Возвращаем пустой массив в случае ошибки
                    }
                }
            }
    }
}
