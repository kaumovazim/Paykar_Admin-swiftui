//
//  StoryManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 07/09/24.
//

import Foundation
import Alamofire
import Combine

class StoryManager: ObservableObject {
    var storyList: [Group] = []
    @Published var isDeleted: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isSuccess: Bool = false
    @Published var uploadURL: String? = nil
    
    func uploadStoryImage(imageData: Data, title: String) {
        isLoading = true
        errorMessage = nil
        uploadURL = nil
        isSuccess = false
        let uploadUrl = "https://paykar.shop/bitrix/api/admin/uploadFile.php"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
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
                    self.createStory(title: title, picturePath: fileLink)
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
    
    func createStory(title: String, picturePath: String) {
        let storyUrl = "https://paykar.shop/bitrix/api/admin/createStories.php"
        let parameters: [String: Any] = [
            "title": title,
            "picture_path": picturePath
        ]
        
        AF.request(storyUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: CreateStoryResponse.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let storyResponse):
                        if storyResponse.success {
                            self.isSuccess = true
                        } else {
                            self.errorMessage = storyResponse.message
                        }
                    case .failure(let error):
                        self.errorMessage = "Story creation failed: \(error.localizedDescription)"
                    }
                }
            }
    }
    func getStoryList() {
        isLoading = true
        errorMessage = nil
        let url = "https://paykar.shop/bitrix/api/admin/getStoryList.php"
        
        AF.request(url).validate().responseDecodable(of: [Group].self) { response in
            DispatchQueue.main.async {
                self.isLoading = false
                switch response.result {
                case .success(let storyList):
                    self.storyList = storyList
                case .failure(let error):
                    self.errorMessage = "Failed to load stories: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private let deleteUrl = "https://paykar.shop/bitrix/api/admin/deleteStories.php"
    func deleteStory(byElementId elementId: Int) {
        isLoading = true
        errorMessage = nil
        isDeleted = false
        let parameters: [String: Any] = ["elementId": elementId]
        
        AF.request(deleteUrl, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: DeleteResponse.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let deleteResponse):
                        if deleteResponse.response == "Ok" {
                            self.isDeleted = true
                        } else {
                            self.errorMessage = "Failed to delete story"
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
