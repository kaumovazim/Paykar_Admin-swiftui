//
//  HistoryManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import Foundation
import Alamofire

class HistoryManager: ObservableObject {
    
    @Published var isLoading = false

    func getHistory(cardCode: String, completion: @escaping ([CardHistoryModel]) -> ()) {
        
        AF.request("https://paykar.shop/bitrix/processing/gethistory.php?CardCode=\(cardCode)").responseDecodable(of: [CardHistoryModel?].self) { response in
            DispatchQueue.main.async {
                self.isLoading = true
            }
            DispatchQueue.main.async {
                switch response.result {
                case .success(let history):
                    self.isLoading = false
                    let validHistory = history.compactMap { $0 }
                    completion(validHistory)
                case .failure(let error):
                    self.isLoading = false
                    completion([CardHistoryModel()])
                    print(error.localizedDescription)
                }
            }
        }
    }
}
