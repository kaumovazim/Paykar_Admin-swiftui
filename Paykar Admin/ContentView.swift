import SwiftUI

struct ContentView: View {
    @StateObject var mainManager = MainManager()
    @State private var isRegistered = false
    @State private var confirmed = false
    @State private var status = ""
    @State private var phone = ""
    @State private var connection = false
    @State private var appReady = false // ← только один управляющий флаг
    @State private var isPressed = false

    var body: some View {
        VStack {
            if !appReady {
                SplashScreenView()
            } else {
                Connection()
            }
        }
        .onAppear {
            reload()
        }
    }

    func reload() {
        connection = mainManager.checkInternetConnection()

        guard connection else {
            appReady = true // даже если нет интернета, закончить splash
            return
        }

        isRegistered = UserManager.shared.isUserRegistered()

        if isRegistered, let admin = UserManager.shared.retrieveUserFromStorage() {
            phone = admin.phone
            AdminManager().findAdminByPhone(phone: phone) { response in
                if let user = response?.user {
                    confirmed = user.confirmed
                    status = user.status

                    let updatedUser = AdminModel(
                        id: user.id,
                        create_date: user.createDate ?? "",
                        firstname: user.firstname,
                        lastname: user.lastname,
                        phone: user.phone,
                        position: user.position,
                        unit: user.unit,
                        level: user.level,
                        device_model: AdminModel.getDeviceModel(),
                        type_os: AdminModel.getTypeOS(),
                        version_os: AdminModel.getOSVersion(),
                        ftoken: AdminModel.getFtoken(),
                        imei: AdminModel.getImei() ?? "",
                        ip_address: AdminModel.getIPAddress(),
                        last_visit: AdminModel.getCurrentTime(),
                        longitude: user.longitude ?? "",
                        latitude: user.latitude ?? "",
                        edit_date: user.editDate ?? "",
                        status: user.status,
                        confirmed: user.confirmed,
                        projects: Projects(
                            shop: user.projects.shop,
                            wallet: user.projects.wallet,
                            logistics: user.projects.logistics,
                            loyalty: user.projects.loyalty,
                            service: user.projects.service,
                            business: user.projects.business,
                            academy: user.projects.academy,
                            parking: user.projects.parking,
                            cashOperations: user.projects.cashOperations,
                            production: user.projects.production
                        )
                    )

                    UserManager.shared.updateUserInStorage(updatedUser: updatedUser)
                }

                appReady = true // ← запускаем отображение интерфейса после всего
            }
        } else {
            appReady = true // нет регистрации — но splash всё равно нужно завершить
        }
    }

    @ViewBuilder
    func Connection() -> some View {
        if connection {
            if isRegistered {
                if phone == "000000000" && status == "active" {
                    HomeView()
                } else {
                    if status == "active" {
                        if confirmed {
                            HomeView()
                        } else {
                            WaitingView()
                        }
                    } else if status == "deactive" {
                        BlockedView()
                    } else {
                        WarningView()
                    }
                }
            } else {
                AuthorizationView()
            }
        } else {
            VStack {
                NoConnectionView()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        appReady = false
                        reload()
                        isPressed = true
                    }
                }) {
                    RepeatButton(isPressed: $isPressed)
                }
                .buttonStyle(PlainButtonStyle()) // Убираем дефолтный стиль
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed = true }
                        .onEnded { _ in isPressed = false }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
