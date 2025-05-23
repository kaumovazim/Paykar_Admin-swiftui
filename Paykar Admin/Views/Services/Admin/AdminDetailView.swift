//
//  AdminDetailView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 11/10/24.
//

import SwiftUI
import CoreLocation

struct AdminDetailView: View {
    @StateObject var mainManager = MainManager()
    @State var admin: AdminListModel
    @State var currentLocation: CLLocationCoordinate2D?
    @State var locationError: String?
    @State var ipBasedLocation: CLLocationCoordinate2D?
    @State var isFetchingIPLocation = false
    @State var updatedSuccess = false
    @State var updatedError = false
    @State var statusChangeSuccess = false
    @State var statusChangeError = false
    @State var alertConnection = false
    @State var progress = false
    @Environment(\.dismiss) var dismiss
    var locationFetcher = LocationFetcher()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("\(admin.firstname) \(admin.lastname)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(admin.status == "active" ? .green : .red).opacity(0.7)
                    Text(admin.status == "active" ? "Активен" : "Заблокирован")
                        .foregroundColor(admin.status == "active" ? .green : .red)
                }
                
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(Color("Accent")).opacity(0.5)
                    Text(admin.phone)
                        .foregroundColor(Color("Accent"))
                }
                
                HStack {
                    Image(systemName: "briefcase.fill")
                        .foregroundColor(Color("Accent")).opacity(0.5)
                    Text(admin.position)
                        .foregroundColor(Color("Accent"))
                }
                
                HStack {
                    Image(systemName: "building.2.fill")
                        .foregroundColor(Color("Accent")).opacity(0.5)
                    Text(admin.unit)
                        .foregroundColor(Color("Accent"))
                }
                
                HStack {
                    Image(systemName: "desktopcomputer")
                        .foregroundColor(Color("Accent")).opacity(0.5)
                    Text("Модель устройства: \(admin.deviceModel ?? "N/A")")
                        .foregroundColor(Color("Accent"))
                }
                
                HStack {
                    Image(systemName: "iphone")
                        .foregroundColor(Color("Accent")).opacity(0.5)
                    Text("Тип ОС: \(admin.typeOS  ?? "N/A")")
                        .foregroundColor(Color("Accent"))
                }
                
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(Color("Accent")).opacity(0.5)
                    Text("Версия ОС: \(admin.versionOS ?? "N/A")")
                        .foregroundColor(Color("Accent"))
                }
                if let ipLocation = ipBasedLocation {
                    Button(action: {
                        openInYandexMaps(latitude: ipLocation.latitude, longitude: ipLocation.longitude)
                    }) {
                        HStack {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .foregroundColor(Color("Accent")).opacity(0.5)
                            Text("IP Address: \(admin.ipAddress ?? "")")
                                .foregroundColor(Color("Accent"))
                        }
                    }
                }
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(Color("Accent")).opacity(0.5)
                    Text("Дата создания: \(mainManager.formattedDateToString(admin.createDate ?? ""))")
                        .foregroundColor(Color("Accent"))
                }
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(Color("Accent")).opacity(0.5)
                    Text("Последний визит: \(mainManager.formattedDateToString(admin.lastVisit ?? ""))")
                        .foregroundColor(Color("Accent"))
                }
                Text("Управление доступом к проектам")
                    .font(.headline)
                VStack{
                    HStack{
                        Image(systemName: admin.projects.shop ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(admin.projects.shop ? .green : .red)
                        
                        Toggle(isOn: $admin.projects.shop) {
                            Text("Пайкар Shop")
                        }
                    }
                    HStack{
                        Image(systemName: admin.projects.wallet ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(admin.projects.wallet ? .green : .red)
                        
                        Toggle(isOn: $admin.projects.wallet) {
                            Text("Пайкар Wallet")
                        }
                    }
                    HStack{
                        Image(systemName: admin.projects.production ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(admin.projects.production ? .green : .red)
                        
                        Toggle(isOn: $admin.projects.production) {
                            Text("Пайкар Production")
                        }
                    }
                    HStack{
                        Image(systemName: admin.projects.loyalty ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(admin.projects.loyalty ? .green : .red)
                        
                        Toggle(isOn: $admin.projects.loyalty) {
                            Text("Пайкар Loyalty")
                        }
                    }
                    HStack{
                        Image(systemName: admin.projects.logistics ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(admin.projects.logistics ? .green : .red)
                        
                        Toggle(isOn: $admin.projects.logistics) {
                            Text("Пайкар Logistics")
                        }
                    }
                    HStack{
                        Image(systemName: admin.projects.academy ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(admin.projects.academy ? .green : .red)
                        
                        Toggle(isOn: $admin.projects.academy) {
                            Text("Пайкар Academy")
                        }
                    }
                    HStack{
                        Image(systemName: admin.projects.business ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(admin.projects.business ? .green : .red)
                        
                        Toggle(isOn: $admin.projects.business) {
                            Text("Пайкар Business")
                        }
                    }
                    HStack{
                        Image(systemName: admin.projects.parking ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(admin.projects.parking ? .green : .red)
                        
                        Toggle(isOn: $admin.projects.parking) {
                            Text("Пайкар Parking")
                        }
                    }
                    .alert("", isPresented: $updatedSuccess) {
                        Button("Ок", role: .cancel, action: {
                            dismiss()
                        })
                    } message: {
                        Text("Пользователь обновлен успешно!")
                    }
                    HStack{
                        Image(systemName: admin.projects.service ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(admin.projects.service ? .green : .red)
                        
                        Toggle(isOn: $admin.projects.service) {
                            Text("Пайкар Service")
                        }
                    }
                    HStack{
                        Image(systemName: admin.projects.cashOperations ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(admin.projects.cashOperations ? .green : .red)
                        
                        Toggle(isOn: $admin.projects.cashOperations) {
                            Text("Контроль кассовых операций")
                        }
                    }
                    .alert("Что то пошло не так!", isPresented: $updatedError) {
                        Button("Побробовать еще", role: .cancel, action: {
                            dismiss()
                        })
                    } message: {
                        Text("Не удалось обновить данные профиля.")
                    }
                    VStack(spacing: 10){
                        Button(action: {
                            saveProjectAccessChanges()
                        }) {
                            if progress {
                                ProgressView()
                            } else {
                                Text("Сохранить изменение")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(Color("Accent"))
                                    .background(Color("Secondary"))
                                    .cornerRadius(20)
                                    .shadow(radius: 2)
                            }
                        }
                        .alert("Что то пошло не так!", isPresented: $alertConnection) {
                            Button("Попробовать еще", role: .cancel, action: {
                                dismiss()
                            })
                        } message: {
                            Text("Проверьте подключение к Интернету и повторите попытку.")
                        }
                        Button(action: {
                            changeUserStatus()
                        }) {
                            if progress {
                                ProgressView()
                            } else {
                                Text(admin.status == "active" ? "Заблокировать" : "Разблокировать")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(admin.status == "active" ? .red : .green)
                                    .background(Color("Secondary"))
                                    .cornerRadius(20)
                                    .shadow(radius: 2)
                            }
                        }
                        .alert("", isPresented: $statusChangeSuccess) {
                            Button("Ок", role: .cancel, action: {
                                dismiss()
                            })
                        } message: {
                            Text(admin.status == "active" ? "Пользователь заблокирован успешно!" : "Пользователь разблокирован успешно!")
                        }
                    }
                    .alert("Что то пошло не так!", isPresented: $statusChangeError) {
                        Button("Побробовать еще", role: .cancel, action: {})
                    } message: {
                        Text(admin.status == "active" ? "Не удалось заблокировать пользователя." : "Не удалось разблокировать пользователя.")
                    }
                    .padding(.top)
                }
            }.padding()
                .padding(.horizontal, 10)
            
                .onAppear {
                    fetchIPLocation(ipAddress: admin.ipAddress ?? "")
                }
        }.scrollIndicators(.hidden)
    }
    
    func fetchIPLocation(ipAddress: String) {
        isFetchingIPLocation = true
        let urlString = "https://ipinfo.io/\(ipAddress)/geo"
        
        guard let url = URL(string: urlString) else {
            locationError = "Invalid IP address"
            isFetchingIPLocation = false
            print(locationError ?? "")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                self.locationError = error?.localizedDescription
                self.isFetchingIPLocation = false
                print(self.locationError ?? "")

                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let locString = json["loc"] as? String {
                    let coords = locString.split(separator: ",")
                    if let lat = Double(coords[0]), let lon = Double(coords[1]) {
                        DispatchQueue.main.async {
                            self.ipBasedLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                            self.isFetchingIPLocation = false
                            print(self.ipBasedLocation ?? "")
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.locationError = "Failed to parse IP location"
                    self.isFetchingIPLocation = false
                    print(self.locationError ?? "")
                }
            }
        }.resume()
    }
    
    func openInYandexMaps(latitude: Double, longitude: Double) {
        let urlString = "yandexmaps://maps.yandex.com/?ll=\(longitude),\(latitude)&z=12"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let webUrlString = "https://maps.yandex.com/?ll=\(longitude),\(latitude)&z=12"
            if let webUrl = URL(string: webUrlString) {
                UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    func saveProjectAccessChanges() {
        if MainManager().checkInternetConnection() {
            AdminManager().updateUser(firstName: admin.firstname,
                                      lastName: admin.lastname,
                                      phone: admin.phone,
                                      position: admin.position,
                                      unit: admin.unit,
                                      shop: admin.projects.shop,
                                      wallet: admin.projects.wallet,
                                      logistics: admin.projects.logistics,
                                      loyalty: admin.projects.loyalty,
                                      service: admin.projects.service,
                                      academy: admin.projects.academy,
                                      business: admin.projects.business,
                                      parking: admin.projects.parking,
                                      cashOperations: admin.projects.cashOperations,
                                      production: admin.projects.production,
                                      status: admin.status,
                                      confirmed: admin.confirmed) { response in
                if (response[0].status != nil) {
                    updatedSuccess = true
                } else {
                    updatedError = true
                }
            }
        } else {
            alertConnection = true
        }
    }
    func changeUserStatus() {
        if admin.status == "active" {
            let status = "blocked"
            if MainManager().checkInternetConnection() {
                AdminManager().updateUser(firstName: admin.firstname,
                                          lastName: admin.lastname,
                                          phone: admin.phone,
                                          position: admin.position,
                                          unit: admin.unit,
                                          shop: admin.projects.shop,
                                          wallet: admin.projects.wallet,
                                          logistics: admin.projects.logistics,
                                          loyalty: admin.projects.loyalty,
                                          service: admin.projects.service,
                                          academy: admin.projects.academy,
                                          business: admin.projects.business,
                                          parking: admin.projects.parking,
                                          cashOperations: admin.projects.cashOperations,
                                          production: admin.projects.production,
                                          status: status,
                                          confirmed: admin.confirmed) { response in
                    if (response[0].status != nil) {
                        statusChangeSuccess = true
                    } else {
                        statusChangeError = true
                    }
                }
            } else {
                alertConnection = true
            }
        } else if admin.status == "blocked" {
            let status = "active"
            if MainManager().checkInternetConnection() {
                AdminManager().updateUser(firstName: admin.firstname,
                                          lastName: admin.lastname,
                                          phone: admin.phone,
                                          position: admin.position,
                                          unit: admin.unit,
                                          shop: admin.projects.shop,
                                          wallet: admin.projects.wallet,
                                          logistics: admin.projects.logistics,
                                          loyalty: admin.projects.loyalty,
                                          service: admin.projects.service,
                                          academy: admin.projects.academy,
                                          business: admin.projects.business,
                                          parking: admin.projects.parking,
                                          cashOperations: admin.projects.cashOperations,
                                          production: admin.projects.production,
                                          status: status,
                                          confirmed: admin.confirmed) { response in
                    if (response[0].status != nil) {
                        statusChangeSuccess = true
                    } else {
                        statusChangeError = true
                    }
                }
            } else {
                alertConnection = true
            }
        }
    }
}
