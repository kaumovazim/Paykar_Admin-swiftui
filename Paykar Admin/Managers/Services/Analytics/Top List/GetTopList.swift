//
//  GetTopList.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 07.04.2025.
//
import Foundation
import Alamofire

class GetTopList: ObservableObject {
    @Published var topList: [TopListBodyModel] = []
    @Published var isLoadinng = false
    
    func getTopList(startDate: String, endDate: String, startTime: String, endTime: String, holidays: Int, allowedUnits: [String], type: String,
                    completion: @escaping ([TopResponseModel]) -> Void = { _ in }) {
        
        isLoadinng = true
        let url = "https://admin.paykar.tj/api/visitsreports/top_list.php"
        let parameters = TopListParametersModel(startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, holidays: holidays, allowedUnits: allowedUnits, type: type)
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: TopResponseModel.self)  { response  in
                DispatchQueue.main.async {
                    self.isLoadinng = false
                }
                switch response.result {
                    case .success(let decodedResponse):
                        var result: [TopListBodyModel] = []
                        switch type { // Используем параметр type вместо topType
                            case "Пропуски":
                                result = decodedResponse.topMissed ?? []
                            case "Недоработки":
                                result = decodedResponse.topUnderworked ?? []
                            case "Переработки":
                                result = decodedResponse.topOvertime ?? []
                            case "Опоздания":
                                result = decodedResponse.topLate ?? []
                            default:
                                result = [] // На случай неверного type
                        }
                        self.topList = result
                    case .failure(let error):
                        print("Ошибка запроса: \(error.localizedDescription)")
                        self.topList = []
                        completion([])
                }
            }
        }
}
