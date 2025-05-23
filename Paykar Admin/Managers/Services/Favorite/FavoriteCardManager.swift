//
//  FavoriteCorrectionManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 02/11/24.
//

import Foundation
import Alamofire

class FavoriteCardManager: ObservableObject {
    
    func addToFavorite(firstName: String, lastName: String, phone: String, status: String, cardCode: String, shortCardCode: String, pointsQuantity: Int, accrualPointsBy: String, completion: @escaping (FavoriteCardResponse) -> ()) {
        let url = "https://admin.paykar.tj/api/loyalty/favorites_cards/create.php"
        let parameters = FavoriteCardCreateParameters(firstName: firstName,
                                                      lastName: lastName,
                                                      phone: phone,
                                                      status: status,
                                                      cardCode: cardCode,
                                                      shortCardCode: shortCardCode,
                                                      pointsQuantity: pointsQuantity,
                                                      accrualPointsBy: accrualPointsBy)
        AF.request(url, method: .post, parameters: parameters,encoder: JSONParameterEncoder.default).responseDecodable(of: FavoriteCardResponse.self) { response in
            DispatchQueue.main.async {
                if response.response?.statusCode == 200 {
                    completion(response.value!)
                } else {
                    let error = response.error?.localizedDescription ?? "Invalid error occured"
                    completion(FavoriteCardResponse(status: error))
                }
            }
        }
    }
    
    func checkFavorite(phone: String, completion: @escaping (FavoriteCardResponse) -> ()) {
        let url = "https://admin.paykar.tj/api/loyalty/favorites_cards/check.php"
        let parameters = FavoriteCardCheckParameters(phone: phone)
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: FavoriteCardResponse.self) { response in
            DispatchQueue.main.async {
                if response.response?.statusCode == 200 {
                    completion(response.value!)
                } else {
                    let error = response.error?.localizedDescription ?? "Invalid error occured"
                    completion(FavoriteCardResponse(status: error))
                }
            }
        }
    }
    func removeFromFavorite(phone: String, status: String, completion: @escaping (FavoriteCardResponse) -> ()) {
        
        let url = "https://admin.paykar.tj/api/loyalty/favorites_cards/update.php"
        let parameters = FavoriteCardRemoveParameters(phone: phone, status: status)
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: FavoriteCardResponse.self) { response in
            DispatchQueue.main.async {
                if response.response?.statusCode == 200 {
                    completion(response.value!)
                    print(response)
                } else {
                    let error = response.error?.localizedDescription ?? "Invalid error occured"
                    completion(FavoriteCardResponse(status: error))
                }
            }
        }
    }
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var favoriteCards: [FavoriteCardListModel] = []
    
    func favoriteCardsList() {
        isLoading = true
        errorMessage = nil

        let url = "https://admin.paykar.tj/api/loyalty/favorites_cards/list.php"
        
        AF.request(url).responseDecodable(of: [FavoriteCardListModel].self) { response in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch response.result {
            case .success(let favoriteCards):
                DispatchQueue.main.async {
                    self.favoriteCards = favoriteCards
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load list: \(error.localizedDescription)"
                    print(self.errorMessage ?? "")
                }
            }
        }
    }
}
