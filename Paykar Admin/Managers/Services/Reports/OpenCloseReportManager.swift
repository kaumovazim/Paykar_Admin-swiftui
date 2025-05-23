//
//  OpenCloseReportManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 11/11/24.
//

import Foundation
import Alamofire

class OpenCloseReportManager: ObservableObject {
    
    @Published var uploadProgress: Double = 0.0
    @Published var uploadStatus: String = ""

    func createReport(firstName: String, lastName: String, userId: String, unit: String, type: String, qrLocation: String, qrCreateDate: String, imageData: Data, completion: @escaping (OpenCloseReportResponse) -> ()) {
        
        isLoading = true

        let uploadURL = "https://admin.paykar.tj/api/admin/open_close_report/upload.php"
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        let url = "https://admin.paykar.tj/api/admin/open_close_report/create.php"
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: uploadURL, headers: headers)
        .uploadProgress { progress in
            DispatchQueue.main.async {
                self.uploadProgress = progress.fractionCompleted
            }
        }
        .responseDecodable(of: OpenCloseUploadResponse.self) { response in
            DispatchQueue.main.async {
                if response.response?.statusCode == 200 {
                    if let imageName = response.value?.image {
                        let parameters = OpenCloseReportCreateParameters(firstName: firstName,
                                                                         lastName: lastName,
                                                                         userId: userId,
                                                                         unit: unit,
                                                                         type: type,
                                                                         qrLocation: qrLocation,
                                                                         qrCreateDate: qrCreateDate,
                                                                         image: imageName)
                        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: OpenCloseReportResponse.self) { response in
                            print(response)
                            if response.response?.statusCode == 200 {
                                completion(response.value!)
                                self.isLoading = false
                                self.uploadProgress = 0.0
                            } else {
                                self.isLoading = false
                                let error = response.error?.localizedDescription ?? "Error"
                                self.uploadStatus = "Create failed: \(error)"
                                print(error)
                                completion(OpenCloseReportResponse(status: "error", message: error))
                                self.uploadProgress = 0.0
                            }
                        }
                    }
                } else {
                    self.isLoading = false
                    let error = response.error?.localizedDescription ?? "Error"
                    self.uploadStatus = "Upload failed: \(error)"
                    print(error)
                    self.uploadProgress = 0.0
                }
            }
        }
    }
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var reports: [OpenCloseReportModel] = []

    func openCloseReportList() {
        isLoading = true
        errorMessage = nil

        let url = "https://admin.paykar.tj/api/admin/open_close_report/list.php"

        AF.request(url).responseDecodable(of: [OpenCloseReportModel].self) { response in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch response.result {
            case .success(let reports):
                DispatchQueue.main.async {
                    self.reports = reports
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load list: \(error.localizedDescription)"
                }
            }
        }
    }
}
