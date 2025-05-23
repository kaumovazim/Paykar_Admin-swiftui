//
//  UpdateAccessCardFunc.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 25.03.2025.
//

import Foundation
import Alamofire


class UpdateCard {
    func updateCard(cardId: Int, completion: @escaping (ResponseAccessCardModel) -> ()) {
        let url = "https://admin.paykar.tj/api/loyalty/access_card/update.php"
        let params = UpdateAccessCardModel(cardId: cardId, status: "deactive")
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
