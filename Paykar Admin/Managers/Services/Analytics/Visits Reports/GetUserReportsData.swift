import Foundation
import Alamofire

class GetUserReportsData: ObservableObject {
    @Published var userData: [UserReportsDataModel] = []
    @Published var isLoading: Bool = false
    
    func getData(firstName: String, lastName: String, startDate: String, endDate: String, startTime: String, endTime: String, holiday: Int,
                 penaltyUnderperformance: Int, incentivesOvertime: Int, absenceForReason: Int,
                 completion: @escaping ([UserReportsDataModel]) -> Void = { _ in }) {
        isLoading = true
        let url = "https://admin.paykar.tj/api/visitsreports/list.php"
        let parameters = UserReportParameterModel(firstName: firstName, lastName: lastName, startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, holidays: holiday, penaltyUnderperformance: penaltyUnderperformance, incentivesOvertime: incentivesOvertime, absenceForReason: absenceForReason)

        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: UserReportsDataModel.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let userDataResponse):
                        self.userData = [userDataResponse] // Преобразуем в массив для совместимости
                        completion([userDataResponse])
                    case .failure(let error):
                        print("Ошибка загрузки данных: \(error.localizedDescription)")
                        self.userData = []
                        completion([])
                    }
                }
            }
    }
}
