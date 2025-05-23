//
//  NotificationManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 26/09/24.
//

import Foundation
import Alamofire
import Combine

class NotificationManager: ObservableObject {
    @Published var categories: [NotificationCategoryModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess: Bool = false
    @Published var isDeleted: Bool = false
    @Published var uploadURL: String? = nil

    private let apiUrl = "https://paykar.shop/bitrix/api/admin/getNotificationList.php"
    func fetchNotifications() {
        isLoading = true
        errorMessage = nil
        
        AF.request(apiUrl)
            .responseDecodable(of: [NotificationCategoryModel].self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let categories):
                        self.categories = categories
                    case .failure(let error):
                        self.errorMessage = "Failed to fetch notifications: \(error.localizedDescription)"
                    }
                }
            }
    }
    func uploadNotificationImage(imageData: Data, title: String, description: String, link: String? = nil) {
        isLoading = true
        errorMessage = nil
        uploadURL = nil
        isSuccess = false
        
        let uploadUrl = "https://paykar.shop/bitrix/api/admin/uploadFile.php"         
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: uploadUrl, headers: headers)
        .validate()
        .responseDecodable(of: UploadResponse.self) { response in
            switch response.result {
            case .success(let uploadResponse):
                if uploadResponse.status == "success", let fileLink = uploadResponse.file_link {
                    self.isLoading = false
                    self.uploadURL = fileLink
                    // After uploading the image, create the notification
                    self.createNotification(title: title, description: description, picturePath: fileLink, link: link)
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = uploadResponse.message
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Upload failed: \(error.localizedDescription)"
                }
            }
        }
    }

    // Function to create a new notification
    func createNotification(title: String, description: String, picturePath: String, link: String? = nil) {
        let parameters: [String: Any] = [
            "title": title,
            "description": description,
            "picture_path": picturePath,
            "link": link ?? ""
        ]
        
        AF.request("https://paykar.shop/bitrix/api/admin/createNotification.php", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: CreateNotificationResponse.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let createResponse):
                        if createResponse.status == "success" {
                            self.isSuccess = true
                        } else {
                            self.errorMessage = createResponse.message
                        }
                    case .failure(let error):
                        self.errorMessage = "Failed to create notification: \(error.localizedDescription)"
                    }
                }
            }
    }
    private let deleteNotificationUrl = "https://paykar.shop/bitrix/api/admin/deleteNotification.php"
    func deleteNotification(byElementId elementId: Int) {
        isLoading = true
        errorMessage = nil
        isDeleted = false
        let parameters: [String: Any] = ["elementId": elementId]
        
        AF.request(deleteNotificationUrl, method: .get, parameters: parameters).validate().responseDecodable(of: DeleteResponse.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    switch response.result {
                    case .success(let deleteResponse):
                        if deleteResponse.response == "Ok" {
                            self.isDeleted = true
                        } else {
                            self.errorMessage = "Failed to delete notification"
                        }
                    case .failure(let error):
                        self.errorMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
    }
}
private struct DeleteResponse: Decodable {
    var response: String
}
