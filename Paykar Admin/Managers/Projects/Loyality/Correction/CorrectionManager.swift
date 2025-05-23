//
//  CorrectionManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import Foundation
import Alamofire
import Combine

class CorrectionManager: ObservableObject {
    
    @Published var isLoading = false
    @Published var successMessage: String? = nil
    @Published var errorMessage: String? = nil
    @Published var correctionRequests: [CorrectionListModel] = []

    func getCardInfomation(cardCode: String, comment: String, addBonus: Double, removeBonus: Double, completion: @escaping ([InfomationModel]) -> ()) {
        
        let parameters = correctionParametersModel(licenseGuid: "E7AB2716-A73A-40DF-BD6F-56EEE7A505B0",
                                                   subjectCode: "ЦБ000001",
                                                   cardCode: cardCode,
                                                   addBonus: addBonus,
                                                   removeBonus: removeBonus,
                                                   addTurnover: 0,
                                                   removeTurnover: 0,
                                                   comment: comment)
        
        AF.request("https://paykar.shop/bitrix/processing/correction_new.php", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: InfomationModel.self) { response in
            DispatchQueue.main.async {
                if(response.response?.statusCode == 200) {
                    completion([response.value!])
                } else {
                    completion([InfomationModel(AcountId: 0, LastName: "", FirstName: "", SurName: "",
                                                Email: "", City: "", Street: "", Birthday: "", Balance: 0, AccumulateOnly: false, Blocked: false, IsPhoneConfirmed: false, PhoneMobile: "", CardCode: "", ClientChipInfo: [ChipModel(MarketProgramName: "", Balance: 0)])])
                }
            }
        }
    }    
    func submitCorrection(firstName: String, lastName: String, phone: String, staffName: String, numberCheck: String, type: String, datePurchase: String, sumPurchase: Double, accruedPoints: Int, cardCode: String, shortCardCode: String, lastCardCode: String, reason: String, userId: String, completion: @escaping (PointCorrectionResponse) -> ()) {
        let url = "https://admin.paykar.tj/api/loyalty/correctionpoints/create.php"
        
        let parametres =  PointCorrectionParameters(firstName: firstName, lastName: lastName, phone: phone, staffName: staffName, numberCheck: numberCheck, type: type, datePurchase: datePurchase, sumPurchase: sumPurchase, accruedPoints: accruedPoints, cardCode: cardCode, shortCardCode: shortCardCode, lastCardCode: lastCardCode, reason: reason, userId: userId)
        
        AF.request(url, method: .post, parameters: parametres, encoder: JSONParameterEncoder.default).responseDecodable(of: PointCorrectionResponse.self) { response in
            DispatchQueue.main.async {
                if(response.response?.statusCode == 200){
                    completion(response.value!)
                } else {
                    completion(PointCorrectionResponse(status: "error", message: "Unknown error occurred!"))
                }
            }
        }
    }
    
    func updateCorrection(userId: String, status: String, statusConfirmed: String, confirmUserId: String, completion: @escaping (PointCorrectionResponse) -> ()) {
        let url = "https://admin.paykar.tj/api/loyalty/correctionpoints/update.php"
        
        let parametres = CorrectionUpdateParameters(userId: userId, status: status, statusConfirmed: statusConfirmed, confirmUserId: confirmUserId)
        
        AF.request(url, method: .post, parameters: parametres, encoder: JSONParameterEncoder.default).responseDecodable(of: PointCorrectionResponse.self) { response in
            DispatchQueue.main.async {
                if(response.response?.statusCode == 200){
                    completion(response.value!)
                } else {
                    let error = response.error
                    completion(PointCorrectionResponse(status: "error", message: "Error \(error?.localizedDescription ?? "")"))
                }
            }
        }
    }

     
    func getCorrectionRequestsList() {
        isLoading = true
        errorMessage = nil
        
        let url = "https://admin.paykar.tj/api/loyalty/correctionpoints/lists.php"
        
        AF.request(url).validate().responseDecodable(of: [CorrectionListModel].self) { response in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch response.result {
            case .success(let correctionRequests):
                DispatchQueue.main.async {
                    self.correctionRequests = correctionRequests
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

