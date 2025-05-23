//
//  OrderManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 02/09/24.
//

import Foundation
import Alamofire

class OrderManager: ObservableObject {
    
    @Published var orders: [OrderModel] = []
    @Published var searchResults: [OrderModel] = []
    @Published var isLoading = false
    @Published var isSearching = false
    @Published var errorMessage: String? = nil
        
    func fetchOrders() {
        isLoading = true
        errorMessage = nil
        
        let url = "https://paykar.shop/bitrix/api/admin/getOrderList.php"
        
        AF.request(url).validate().responseDecodable(of: [OrderModel].self) { response in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch response.result {
            case .success(let orders):
                DispatchQueue.main.async {
                    self.orders = orders
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load orders: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func convertToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss" 
        return dateFormatter.date(from: dateString) ?? Date.distantPast
    }
    
    func getOrderById(orderId: Int) {
        let url = "https://paykar.shop/bitrix/api/admin/getOrderById.php?orderId=\(orderId)"
        isSearching = true

        AF.request(url).validate().responseDecodable(of: OrderModel.self) { response in
            DispatchQueue.main.async {
                self.isSearching = false
            }
            switch response.result {
            case .success(let order):
                DispatchQueue.main.async {
                    self.searchResults = [order]
                }
            case .failure(let error):
                self.searchResults = []
            }
        }
    }
    func getOrderByPhone(phone: String) {
        let url = "https://paykar.shop/bitrix/api/admin/getOrderByPhone.php"
        let parameters: [String: String] = ["phone": phone]
        isSearching = true

        AF.request(url, parameters: parameters).validate().responseDecodable(of: [OrderModel].self) { response in
            DispatchQueue.main.async {
                self.isSearching = false
            }
            switch response.result {
            case .success(let orders):
                self.searchResults = orders
            case .failure(let error):
                self.searchResults = []
            }
        }
    }
}
