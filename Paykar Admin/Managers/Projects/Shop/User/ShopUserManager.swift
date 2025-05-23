//
//  UserManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 30/08/24.
//

import Foundation
import Alamofire
import Combine

class ShopUserManager: ObservableObject {
    
    @Published var newUsers: [UserModel] = []
    @Published var originalUsers: [UserModel] = [] 
    @Published var searchedUsers: [UserDataModel]  = []
    @Published var user: UserDataModel?
    @Published var device: [DeviceModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var statusMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = ShopUserManager()
    private init() {}
    
    func getNewUsers() {
        let url = "https://paykar.shop/bitrix/api/admin/getUserList.php"
        isLoading = true
        errorMessage = nil
        
        AF.request(url, method: .get).validate().responseData { response in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch response.result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                    
                    if decodedResponse.status.lowercased() == "success" {
                        DispatchQueue.main.async {
                            self.newUsers = decodedResponse.users
                            self.originalUsers = decodedResponse.users
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "API returned status: \(decodedResponse.status)"
                        }
                    }
                } catch let decodingError {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to decode response: \(decodingError.localizedDescription)"
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    func resetToOriginalOrder() {
        newUsers = originalUsers
    }
    
    func findUserByPhone(byPhone phone: String) {
        let urlString = "https://mobileapp.paykar.tj/api/usersMobile/user_data.php"
        guard var urlComponents = URLComponents(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "phone", value: phone)
        ]
        
        guard let url = urlComponents.url else {
            errorMessage = "Invalid URL"
            return
        }
        self.isLoading = true
        self.errorMessage = nil
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: UserDataModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch user: \(error.localizedDescription)"
                case .finished:
                    break
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] user in
                self?.searchedUsers = [user]
            })
            .store(in: &cancellables)
    }
    func deactivateUser(userId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "https://example.com/deactivate_user.php"
        let parameters: [String: Any] = ["id": userId]

        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: [String: String].self) { response in
                switch response.result {
                case .success(let result):
                    if let message = result["successfully"] {
                        completion(.success(message))
                    } else if let error = result["error"] {
                        completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: error])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
