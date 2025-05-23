//
//  UserStorage.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI
import Foundation

class UserStorage: ObservableObject {
    
    private var userDefaults = UserDefaults.standard
    private var userIdKey: String = "USERID"
    private var userFIdKey: String = "USERFID"
    private var userFirstNameKey: String = "USERNAME"
    private var userLastNameKey: String = "USERLASTNAME"
    private var userPhoneKey: String = "USERPHONE"
    private var userPositionKey: String = "USERPOSITION"
    private var userSubdivisionKey: String = "USERSUBDIVISION"
    private var userLevelKey: String = "USERLEVEL"
    private var userDeviceModelKey: String = "DEVICEMODEL"
    private var userTypeOSKey: String = "USERTYPEOS"
    private var userVersionOSKey: String = "VERSIONOS"
    private var userImeIKey: String = "USERIMEI"
    private var userAccessProjectKey: String = "USERACCESSPROJECT"
    private var userIpAddressKey: String = "USERIPADDRESS"
    private var userAuthorizationConfirm: String = "USERAUTHORIZATIONCONFIRM"
    private var ftoken: String = "FTOKENNOT"
    
    func authorizationUser(phone: String, completion: @escaping (Bool) -> ()) {
        AuthorizationManager().login(phone: phone) { user in
            if(user.id != nil) {
                let id = user.id
                let phone = user.phone
                self.userDefaults.set(true, forKey: self.userAuthorizationConfirm)
                self.userDefaults.set(id, forKey: self.userIdKey)
                self.userDefaults.set(phone, forKey: self.userPhoneKey)
                self.userDefaults.synchronize()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func registrationUser(id: Int, firstName: String, lastName: String, phone: String, position: String, unit: String, level: String, deviceModel: String, typeOS: String, versionOS: String, ftoken: String, imei: String, accessProject: String, ipAddress: String,  completion: @escaping (Bool) -> ()) {
        RegistrationManager().registration(id: id, firstName: firstName, lastName: lastName, phone: phone, position: position, unit: unit, level: level, deviceModel: deviceModel, typeOS: typeOS, versionOS: versionOS, ftoken: ftoken, imei: imei, accessProject: accessProject, ipAddress: ipAddress) { user in
            if(user.id != 0) {
                let id = user.id
                let fid = user.fid
                self.userDefaults.set(true, forKey: self.userAuthorizationConfirm)
                self.userDefaults.set(id, forKey: self.userIdKey)
                self.userDefaults.set(fid, forKey: self.userFIdKey)
                self.userDefaults.set(firstName, forKey: self.userFirstNameKey)
                self.userDefaults.set(lastName, forKey: self.userLastNameKey)
                self.userDefaults.set(phone, forKey: self.userPhoneKey)
                self.userDefaults.set(position, forKey: self.userPositionKey)
                self.userDefaults.set(unit, forKey: self.userSubdivisionKey)
                self.userDefaults.synchronize()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func setUpdateUser(userId: Int, firstName: String, lastName: String, phone: String, position: String, unit: String, level: String, deviceModel: String, typeOS: String, versionOS: String, ftoken: String, imei: String, accessProject: String, ipAddress: String,  completion: @escaping (Bool) -> ()) {
        ProfileManager().ChangeInformation(userId: userId, firstName: firstName, lastName: lastName, phone: phone, position: position, unit: unit, level: level, deviceModel: deviceModel, typeOS: typeOS, versionOS: versionOS, ftoken: ftoken, imei: imei, accessProject: accessProject, ipAddress: ipAddress) { user in
            if user.successfully != nil{
                self.userDefaults.set(true, forKey: self.userAuthorizationConfirm)
                self.userDefaults.set(userId, forKey: self.userIdKey)
                self.userDefaults.set(firstName, forKey: self.userFirstNameKey)
                self.userDefaults.set(lastName, forKey: self.userLastNameKey)
                self.userDefaults.set(phone, forKey: self.userPhoneKey)
                self.userDefaults.set(position, forKey: self.userPositionKey)
                self.userDefaults.set(unit, forKey: self.userSubdivisionKey)
                self.userDefaults.synchronize()
                completion(true)
            } else{
                completion(false)
            }
                
        }
    }
    func getUpdateUser(completion: @escaping (ChangedDataModel) -> ()) {
        self.userDefaults.synchronize()
        let id = userDefaults.integer(forKey: userIdKey)
        let firstName = userDefaults.string(forKey: userFirstNameKey) ?? ""
        let lastName = userDefaults.string(forKey: userLastNameKey) ?? ""
        let phone = userDefaults.string(forKey: userPhoneKey) ?? ""
        let position = userDefaults.string(forKey: userPositionKey) ?? ""
        let unit = userDefaults.string(forKey: userSubdivisionKey) ?? ""
        let level = userDefaults.string(forKey: userLevelKey) ?? ""
        let deviceModel = userDefaults.string(forKey: userDeviceModelKey) ?? ""
        let typeOS = userDefaults.string(forKey: userTypeOSKey) ?? ""
        let versionOS = userDefaults.string(forKey: userVersionOSKey) ?? ""
        let ftoken = userDefaults.string(forKey: ftoken) ?? ""
        let imei = userDefaults.string(forKey: userImeIKey) ?? ""
        let accessProject = userDefaults.string(forKey: userAccessProjectKey) ?? ""
        let ipAddress = userDefaults.string(forKey: userIpAddressKey) ?? ""
        _ = userDefaults.bool(forKey: userAuthorizationConfirm)
        let user = ChangedDataModel(firstName: firstName, lastName: lastName, phone: phone, position: position, unit: unit, level: level, deviceModel: deviceModel, typeOS: typeOS, versionOS: versionOS, ftoken: ftoken, imei: imei, accessProject: accessProject, ipAddress: ipAddress)
        completion(user)
    }
    func getUserStorage(completion: @escaping (UserStorageModel) -> ()) {
        self.userDefaults.synchronize()
        let id = userDefaults.string(forKey: userIdKey) ?? ""
        _ = userDefaults.string(forKey: userFIdKey) ?? ""
        let firstName = userDefaults.string(forKey: userFirstNameKey) ?? ""
        let lastName = userDefaults.string(forKey: userLastNameKey) ?? ""
        let phone = userDefaults.string(forKey: userPhoneKey) ?? ""
        let position = userDefaults.string(forKey: userPositionKey) ?? ""
        let unit = userDefaults.string(forKey: userSubdivisionKey) ?? ""
        let confirmUser = userDefaults.bool(forKey: userAuthorizationConfirm)
        let user = UserStorageModel(id: id, firstName: firstName, lastName: lastName, phone: phone,position: position, unit: unit, userConfirm: confirmUser)
        completion(user)
    }
    func getUserId() -> Int {
        let userId = Int(userDefaults.string(forKey: userIdKey) ?? "0")!
        return userId
    }
    func getComfirmUser() -> Bool {
        let user = userDefaults.bool(forKey: userAuthorizationConfirm)
        return user
    }
    func ftoken(ftoken: String){
        self.userDefaults.set(ftoken, forKey: self.ftoken)
        self.userDefaults.synchronize()
    }
    func getFtoken() -> String{
        self.userDefaults.synchronize()
        let ftoken = userDefaults.string(forKey: ftoken) ?? ""
        return ftoken
    }
    func cleanStorage() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        UserDefaults.standard.synchronize()
    }
//    func getDeviceID() -> String {
//            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
//                self,userDefaults "\(uuid)"
//            } else {
//                return "Unable to retrieve device UUID"
//            }
//        }
//    func getDeviceModel() -> String {
//            if var deviceModel = UIDevice.modelName {
//                self,userDefaults "\(uuid)"
//            } else {
//                return "Unable to retrieve device UUID"
//            }
//        }
//
//    var versionOS: UIDevice.current.systemVersion

    func getIPAddress() -> String {
            var address: String?
            var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
            if getifaddrs(&ifaddr) == 0 {
                var ptr = ifaddr
                while ptr != nil {
                    defer { ptr = ptr?.pointee.ifa_next }
                    
                    guard let interface = ptr?.pointee else { return "" }
                    let addrFamily = interface.ifa_addr.pointee.sa_family
                    if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                        let name: String = String(cString: (interface.ifa_name))
                        if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                            address = String(cString: hostname)
                        }
                    }
                }
                freeifaddrs(ifaddr)
            }
            return address ?? ""
        }
}

