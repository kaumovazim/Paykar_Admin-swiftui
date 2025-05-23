//
//  SendAnswers.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 27.03.2025.
//

import Foundation
import Alamofire


class SendAnswers: ObservableObject {
    @Published var answers: [AnswerBodyModel] = []
    @Published var questions: [CheckListDataModel] = [] // Количество вопросов

    // Функция для добавления ответа и отправки на сервер
    func addAnswer(questionId: String, answer: Bool, comment: String, completion: @escaping (ResponseAnswerModel?) -> ()) {
        // Добавляем новый ответ в массив
        let newAnswer = AnswerBodyModel(questionId: questionId, answer: answer, comment: comment)
        answers.append(newAnswer)

        if answers.count == questions.count {
            answers(completion: completion)
        } else {
            completion(nil) // Ответ принят, продолжаем собирать
        }
    }
    func answers(completion: @escaping (ResponseAnswerModel?) -> ()) {
        // Получаем adminData из хранилища
        if let adminData = UserManager.shared.retrieveUserFromStorage() {
            let url = "https://admin.paykar.tj/api/admin/check_list/answers.php"
            let userId = adminData.id
            let parameters = AnswerModel(userId: userId, answers: answers)
            // Выполнение POST-запроса с параметрами
            AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: ResponseAnswerModel.self) { response in
                    DispatchQueue.main.async {
                        // Проверка на успешный ответ (статус 200)
                        if response.response?.statusCode == 200 {
                            if let value = response.value {
                                completion(value)  // Возвращаем данные модели
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
