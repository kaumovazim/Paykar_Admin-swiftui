import Foundation
import Alamofire

class ListAccessCard: ObservableObject {
    @Published var cards: [ListAccessCardModel] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    func getCardList() {
        
        isLoading = true
        let url = "https://admin.paykar.tj/api/loyalty/access_card/list.php"
        
        AF.request(url).validate().responseDecodable(of: [ListAccessCardModel].self) { response in
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch response.result {
            case .success(let cardList):
                if let adminData = UserManager.shared.retrieveUserFromStorage() {
                    let userPosition = adminData.position
                    let userUnit = adminData.unit
                    if userPosition == "Супер Админ" {
                        self.cards = cardList
                    } else {
                        self.cards = cardList.filter {
                            ($0.unit?.lowercased() == userUnit.lowercased())
                        }
                    }
                } else {
                    print("Не удалось получить данные администратора")
                }
                
            case .failure(let error):
                print(" Ошибка загрузки карт: \(error.localizedDescription)")
            }
        }
    }
}

