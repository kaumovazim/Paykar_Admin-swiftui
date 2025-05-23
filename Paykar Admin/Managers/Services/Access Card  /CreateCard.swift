
import Foundation
import Alamofire


class CreateCard {
    func createCard(numberCard: String, completion: @escaping (ResponseAccessCardModel) -> ()) {
        if let adminData = UserManager.shared.retrieveUserFromStorage() {
            let url = "https://admin.paykar.tj/api/loyalty/access_card/create.php"
            let unit = adminData.unit
            let addCard = "\(adminData.firstname) \(adminData.lastname)"
            let position = adminData.position
            if numberCard.count < 13 {
                print("error")
            } else {
                let params = AddAccessCardModel(numberCard: numberCard, unit: unit, addCard: addCard, position: position)
                AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default).responseDecodable(of: ResponseAccessCardModel.self) { response in
                    DispatchQueue.main.async {
                        print(response)
                        if response.response?.statusCode == 200 {
                            print(response.value ?? "no value")
                            completion(response.value!)
                        } else {
                            let errorMessage = response.error?.localizedDescription ?? "Unknown error occurred."
                            completion(ResponseAccessCardModel(status: "error"))
                            print(errorMessage)
                        }
                    }
                }
            }
        }
    }
}
