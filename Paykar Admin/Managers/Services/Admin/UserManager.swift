import Foundation
import SwiftUI


class UserManager {
    
    static let shared = UserManager()
    
    private init() {}
    
//    func gatherUserData(firstName: String, lastName: String, phone: String, position: String, unit: String) -> AdminModel {
//        let deviceModel = AdminModel.getDeviceModel()
//        let typeOS = AdminModel.getTypeOS()
//        let versionOS = AdminModel.getOSVersion()
//        let ftoken = AdminModel.getFtoken()
//        let imei = AdminModel.getImei() ?? ""
//        let ipAddress = AdminModel.getIPAddress()
//        let status = "active"
//        let createDate = AdminModel.getCurrentTime()
//        var lastVisit = AdminModel.getCurrentTime()
//        var
//        let locationFetcher = LocationFetcher()
//        var latitude = ""
//        var longitude = ""
//        
//        locationFetcher.getCurrentLocation { coordinates, error in
//            if let coordinates = coordinates {
//                latitude = String(coordinates.latitude)
//                longitude = String(coordinates.longitude)
//            } else if error != nil {
//                latitude = ""
//                longitude = ""
//            }
//        }
//        
//        let projects = Projects(shop: position == "Супер Админ" ? true : false, wallet: position == "Супер Админ" ? true : false, logistics: position == "Супер Админ" ? true : false, loyalty: position == "Супер Админ" ? true : false, service: position == "Супер Админ" ? true : false, business: position == "Супер Админ" ? true : false, academy: position == "Супер Админ" ? true : false, parking: position == "Супер Админ" ? true : false, cashOperations: position == "Супер Админ" ? true : false, production: position == "Супер Админ" ? true : false)
//        
//        let newUser = AdminModel(
//            id: "",
//            createDate: createDate,
//            firstname: firstName,
//            lastname: lastName,
//            phone: phone,
//            position: position,
//            unit: unit, level: "0",
//            device_model: deviceModel,
//            type_os: typeOS,
//            versionOS: versionOS,
//            ftoken: ftoken,
//            imei: imei,
//            ipAddress: ipAddress,
//            lastVisit: lastVisit,
//            longitude: longitude,
//            latitude: latitude,
//            edit_date: <#T##String#>
//            status: status,
//            confirmed: false,
//            projects: projects
//        )
//        
//        return newUser
//    }
    
    func saveUserToStorage(_ user: AdminModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "admin")
        } else {
        }
    }
    
    func retrieveUserFromStorage() -> AdminModel? {
        if let savedUserData = UserDefaults.standard.data(forKey: "admin") {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(AdminModel.self, from: savedUserData) {
                return loadedUser
            } else {
            }
        }
        return nil
    }
    
    func isUserRegistered() -> Bool {
        return retrieveUserFromStorage() != nil
    }
    
    func logOutUser() {
        UserDefaults.standard.removeObject(forKey: "admin")
    }
    
    func updateUserInStorage(updatedUser: AdminModel) {
        guard retrieveUserFromStorage() != nil else {
            return
        }
        saveUserToStorage(updatedUser)
    }
    

}


