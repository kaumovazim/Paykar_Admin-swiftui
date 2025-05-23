//
//  ProductListManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 29/10/24.
//

import Foundation
import Alamofire

class ProductListManager: ObservableObject {
    
    @Published var products: [ProductDataModel] = []
    
    func getProductlist(folderId: Int, page: Int, completion: @escaping ([ProductDataModel]) -> ()) {
        let url = "https://paykar.cloud39.ru/BonusWebApi/api/Catalog/GetProductsByFolder?License=E7AB2716-A73A-40DF-BD6F-56EEE7A505B0&folderId=\(folderId)&page=\(page)&pageSize=500"

        AF.request(url, method: .post).responseDecodable(of: ProductDataModel.self) { response in
            DispatchQueue.main.async {
                if response.response?.statusCode == 200 {
                    completion([response.value!])
                } else {
                    print("Decoding error: \(response.error?.localizedDescription ?? "Unknown error")")
                    completion([])
                }
            }
        }
    }
}

