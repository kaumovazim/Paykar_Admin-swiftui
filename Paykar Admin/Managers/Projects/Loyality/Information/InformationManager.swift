//
//  InformationManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import Foundation
import Alamofire

class InfomationManager: ObservableObject {
    
    
    func getCardInfomation(completion: @escaping ([InfomationModel]) -> (), cardCode: String) {
        
        let parameters = infomationParametersModel(LicenseGuid: "E7AB2716-A73A-40DF-BD6F-56EEE7A505B0", ShortCardCode: cardCode)
        
        AF.request("https://paykar.cloud39.ru/BonusWebApi/api/processing/info", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: InfomationModel.self) { response in
                DispatchQueue.main.async {
                    print(response)
                    if(response.response?.statusCode == 200) {
                        completion([response.value!])
                    } else {
                        completion([InfomationModel(AcountId: 0, LastName: "", FirstName: "", SurName: "",
                                                   Email: "", City: "", Street: "", Birthday: "", Balance: 0, AccumulateOnly: false, Blocked: false, IsPhoneConfirmed: false, PhoneMobile: "", CardCode: "", ClientChipInfo: [ChipModel(MarketProgramName: "", Balance: 0)])])
                    }
            }
        }
    }
    func getCardInfomationBarcode(completion: @escaping ([InfomationModel]) -> (), cardCode: String) {
        
        let parameters = infomationBarcodeParametersModel(LicenseGuid: "E7AB2716-A73A-40DF-BD6F-56EEE7A505B0", CardCode: cardCode)
        
        AF.request("https://paykar.cloud39.ru/BonusWebApi/api/processing/info", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: InfomationModel.self) { response in
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
    func getCardInfomationByPhone(completion: @escaping ([InfomationModel]) -> (), phone: String) {
        
        let parameters = infomationByPhoneParametersModel(LicenseGuid: "E7AB2716-A73A-40DF-BD6F-56EEE7A505B0", MobilePhone: "+992\(phone)")
        
        AF.request("https://paykar.cloud39.ru/BonusWebApi/api/processing/info", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: InfomationModel.self) { response in
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

    func getCertificateInfomation(completion: @escaping (CertificateInfomationModel) -> (), certificateCode: String) {
        
        let parameters = infomationBarcodeParametersModel(LicenseGuid: "E7AB2716-A73A-40DF-BD6F-56EEE7A505B0", CardCode: certificateCode)
        
        AF.request("https://paykar.cloud39.ru/BonusWebApi/api/processing/info", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: CertificateInfomationModel.self) { response in
                DispatchQueue.main.async {
                    if(response.response?.statusCode == 200) {
                        completion(response.value!)
                        print(response.value!)
                    } else {
                        completion(CertificateInfomationModel(Balance: 0, StartDate: "", FinishDate: "", CardStatus: "", CardCode: ""))
                    }
            }
        }
    }
    func cardInformationUpdate(clientId: String, phoneMobile: String, lastName: String?, firstName: String?, secondName: String?, birthdate: String?, email: String?, city: String?, street: String?, house: String?, acceptSms: Bool, accumulateOnly: Bool, editDate: String, editor: Editor, completion: @escaping (InfomationModel) -> ()) {
        
        let parameters = InfomationUpdateParameters(clientId: clientId, phoneMobile: phoneMobile, lastName: lastName, firstName: firstName, secondName: secondName, birthdate: birthdate, email: email, city: city, street: street, house: house, acceptSms: acceptSms, accumulateOnly: accumulateOnly, editDate: editDate, editor: editor)
        
        AF.request("https://paykar.cloud39.ru/BonusWebApi/api/processing/info", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: InfomationModel.self) { response in
                DispatchQueue.main.async {
                    print(response)
                    if(response.response?.statusCode == 200) {
                        completion(response.value!)
                    } else {
                        completion(InfomationModel(AcountId: 0, LastName: "", FirstName: "", SurName: "",
                                                   Email: "", City: "", Street: "", Birthday: "", Balance: 0, AccumulateOnly: false, Blocked: false, IsPhoneConfirmed: false, PhoneMobile: "", CardCode: "", ClientChipInfo: [ChipModel(MarketProgramName: "", Balance: 0)]))
                        let error = response.error?.localizedDescription
                        print(error ?? "")
                    }
            }
        }
    }
    func setProfileInfo(info: SetProfileInfoModel ,completion: @escaping (SetProfileInfoModelResponse) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            AF.request("https://paykar.cloud39.ru/BonusWebApi/SiteController/SetProfileInfo?LicenseGuid=D66B2D9C-C17C-4D03-868D-477461CC70DB", method: .post, parameters: info, encoder: JSONParameterEncoder.default).responseDecodable(of: SetProfileInfoModelResponse.self) { response in
                
                let result = response.result
                switch result{
                case .success(let value):
                    DispatchQueue.main.async {
                        completion(value)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        completion(SetProfileInfoModelResponse())
                    }
                }
            }
        }
    }
    
}

