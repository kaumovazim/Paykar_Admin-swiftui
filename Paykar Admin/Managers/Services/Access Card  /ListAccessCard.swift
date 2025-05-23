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
                            .filter {($0.unit?.lowercased() == userUnit.lowercased()) && ($0.status == "active")}
                            .sorted { ($0.create_date ?? "") > ($1.create_date ?? "") }
                    } else {
                        self.cards = cardList
                            .filter {($0.unit?.lowercased() == userUnit.lowercased()) && ($0.status == "active") && ($0.position?.lowercased() == userPosition.lowercased())}
                            .sorted { ($0.create_date ?? "") > ($1.create_date ?? "") }
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

