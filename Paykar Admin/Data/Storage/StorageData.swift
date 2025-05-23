import SwiftUI

class StorageData: ObservableObject {
    
    @AppStorage("AcountId") var acountId = 0
    @AppStorage("ClientId") var clientId = ""
    @AppStorage("PhoneMobile") var phoneMobile = ""
    @AppStorage("CardCode") var cardCode = ""
    @AppStorage("ShortCardCode") var shortCardCode = ""
    @AppStorage("Email") var email = ""
    
    @AppStorage("LastName") var lastName = ""
    @AppStorage("FirstName") var firstName = ""
    @AppStorage("SurName") var secondName = ""
    @AppStorage("City") var city = ""
    @AppStorage("Street") var street = ""
    @AppStorage("House") var house = ""
    @AppStorage("Birthday") var birthday = ""
    @AppStorage("Balance") var balance = 0.0
    
    @AppStorage("AccumulateOnly") var accumulateOnly = false
    @AppStorage("Blocked") var blocked = false
    @AppStorage("IsPhoneConfirmed") var isPhoneConfirmed = false

    private let clientChipInfoKey = "ClientChipInfo"
    
    var clientChipinfo: [ChipModel] {
        get {
            if let data = UserDefaults.standard.data(forKey: clientChipInfoKey) {
                return (try? JSONDecoder().decode([ChipModel].self, from: data)) ?? []
            }
            return []
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: clientChipInfoKey)
            }
        }
    }
    
    func cleanStorageData() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    func saveHistoryList(value: [CardHistoryModel]) {
        if let encode = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encode, forKey: "historyList")
        }
    }
    
    func getHistoryList() -> [CardHistoryModel] {
        if let data = UserDefaults.standard.data(forKey: "historyList") {
            if let decoder = try? JSONDecoder().decode([CardHistoryModel].self, from: data) {
                return decoder
            }
        }
        return []
    }
    
    func convertDateTimeToString(date: String) -> String {
        let dateString = date.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        guard let jdate = dateFormatter.date(from: dateString) else { return date }
        
        dateFormatter.dateFormat = "d MMM yyyy | HH:mm"
        return dateFormatter.string(from: jdate)
    }
    
    func convertDateToString(date: String) -> String {
        let dateString = date.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let jdate = dateFormatter.date(from: dateString) ?? Date()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: jdate)
    }
    
    func convertStringToDate(dateString: String) -> Date {
        let dateString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: dateString) ?? Date()
    }
}
