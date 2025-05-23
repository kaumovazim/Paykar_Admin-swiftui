//
//  ProfileModel.swift
//  Paykar
//
//  Created by User on 04/04/23.
//

import Foundation
import CoreLocation
import UIKit
import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications

struct AdminModel: Identifiable, Codable {
    let id: Int
    let create_date: String?
    var firstname: String
    var lastname: String
    let phone: String
    var position: String
    var unit: String
    var level: String
    var device_model: String?
    var type_os: String?
    var version_os: String?
    var ftoken: String?
    var imei: String?
    var ip_address: String?
    var last_visit: String?
    var longitude: String?
    var latitude: String?
    var edit_date: String?
    var status: String
    var confirmed: Bool
    var projects: Projects

    static func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelIdentifier = withUnsafePointer(to: &systemInfo.machine) { ptr in
            String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
        }
        return mapToDevice(identifier: modelIdentifier)
    }
    private static func mapToDevice(identifier: String) -> String {
        switch identifier {
        case "iPod5,1":                                 return "iPod touch (5th generation)"
        case "iPod7,1":                                 return "iPod touch (6th generation)"
        case "iPod9,1":                                 return "iPod touch (7th generation)"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE (2nd generation)"
        case "iPhone13,1":                              return "iPhone 12 mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
        case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
        case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
        case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
        case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
        case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
        case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
        case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "AudioAccessory5,1":                       return "HomePod mini"
        case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
        default: return identifier
        }
    }
    static func getTypeOS() -> String {
#if os(iOS)
        return "iOS"
#elseif os(macOS)
        return "macOS"
#elseif os(tvOS)
        return "tvOS"
#elseif os(watchOS)
        return "watchOS"
#else
        return "Unknown OS"
#endif
    }
    static func getOSVersion() -> String {
#if os(iOS) || os(tvOS) || os(watchOS)
        return UIDevice.current.systemVersion
#elseif os(macOS)
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
#else
        return "Unknown Version"
#endif
    }
    static func getFtoken() -> String {
        if let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") {
            return fcmToken
        } else {
            return "No FCM Token Found"
        }
    }
    static func getImei() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    static func getIPAddress() -> String {
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
    static func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}
struct Projects: Codable {
    var shop: Bool
    var wallet: Bool
    var logistics: Bool
    var loyalty: Bool
    var service: Bool
    var business: Bool
    var academy: Bool
    var parking: Bool
    var cashOperations: Bool
    var production: Bool
}

struct UpdateLastVisitModel: Codable {
    var status: String?
}

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((CLLocationCoordinate2D?, Error?) -> Void)?
    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        locationCompletion = completion
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationCompletion?(location.coordinate, nil)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(nil, error)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        
        UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
        
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: ["token": fcmToken])
        
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if userInfo[gcmMessageIDKey] != nil {
        }
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if userInfo[gcmMessageIDKey] != nil {
        }
        
        completionHandler()
    }
}
