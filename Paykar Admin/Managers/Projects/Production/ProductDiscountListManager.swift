//
//  ProductDiscountListManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 01/11/24.
//

import Foundation
import Alamofire

class ProductDiscountListManager: ObservableObject {
    
    @Published var isLoading = false
    @Published var discountList: [DiscountProgram] = []
    @Published var errorMessage: String? = nil

    func getDiscountList()  {
        isLoading = true
        errorMessage = nil
        let url = "https://production.paykar.tj/func/promotion/marketinglist.php?department=Пайкар"
        
        AF.request(url, method: .get).responseDecodable(of: [DiscountProgram].self) { response in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch response.result {
            case .success(let discountList):
                DispatchQueue.main.async {
                    self.discountList = discountList
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load discount list: \(error.localizedDescription)"
                }
            }
        }
    }
}
