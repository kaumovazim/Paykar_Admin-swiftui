//
//  MainManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI
import SystemConfiguration
import Network
import Foundation
import CoreFoundation


class MainManager: MainService, ObservableObject {

    
    func checkInternetConnection() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }
    
    func convertSVGToImage(image: String, width: Int, height: Int) -> UIImage {
    let imgs : UIImage = UIImage(named: "\(image)")!
    let size = imgs.size
    let uSize = CGSize(width: width, height: height)
    let uWidth = uSize.width / imgs.size.width
    let uHeight = uSize.height / imgs.size.height
    var newSize: CGSize
    if uWidth > uHeight {
    newSize = CGSize(width: size.width * uHeight, height: size.height * uHeight)
    } else {
    newSize = CGSize(width: size.width * uWidth, height: size.height * uWidth)
    }
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    imgs.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}
    
    func convertDateToString(date: String) -> String {
        let dateString = date.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let jdate = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "d MMM yyyy | HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: jdate)
        return timeStamp
    }
    
    func convertDateNoTomeToString(date: String) -> String {
        let dateString = date.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let jdate = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: jdate)
        return timeStamp
    }
     func formattedDate(from input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyy-MM.dd"
        inputFormatter.locale = Locale(identifier: "ru_RU")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "ru_RU")

        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        } else {
            return "Неверная дата"
        }
    }

    func formattedDateToString(_ dateString: String) -> String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = formatter.date(from: dateString) {
            
            formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            return formatter.string(from: date)
        }
        
        return dateString
    }


    func convertStringToDate(date: String)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: date)
        return date
    }
    
    func convertDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
    
    func convertDateIn(dateIn: String) -> String {
        let dateString = dateIn.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let jdate = dateFormatter.date(from: dateString) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: jdate)
        return timeStamp
    }
    
}

