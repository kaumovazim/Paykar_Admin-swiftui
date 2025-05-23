//
//  QuestionList.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 27.03.2025.
//
import Foundation
import Alamofire


class QuestionList: ObservableObject {
    @Published var questions: [CheckListDataModel] = []
    @Published var isLoading = false
    func question(completion: @escaping (QuestionListModel?) -> ()) {
        // Получаем adminData из хранилища
        isLoading = true
        if let adminData = UserManager.shared.retrieveUserFromStorage() {
            let url = "https://admin.paykar.tj/api/admin/check_list/list.php"
            
            // Используем position из adminData
            let position = adminData.position
            
            // Параметры для запроса
            let parameters: [String: String] = [
                "position": position
            ]
            
            // Выполнение POST-запроса с параметрами
            AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: QuestionListModel.self) { response in
                    self.isLoading = false
                    DispatchQueue.main.async {
                        // Проверка на успешный ответ (статус 200)
                        if response.response?.statusCode == 200 {
                            if let value = response.value {
                                self.questions = value.checkListData// Сохраняем список вопросов
                                completion(value)    // Возвращаем данные модели
                            } else {
                                completion(nil)  // Если данные пустые, возвращаем nil
                            }
                        } else {
                            let errorMessage = response.error?.localizedDescription ?? "Unknown error occurred."
                            print(errorMessage)
                            completion(nil)  // В случае ошибки, возвращаем nil
                        }
                    }
                }
        } else {
            // Если данные администратора не найдены, возвращаем nil
            completion(nil)
        }
    }
}


