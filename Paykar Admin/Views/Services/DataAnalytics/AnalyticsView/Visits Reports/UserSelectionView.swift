import SwiftUI
import Alamofire

struct UserSelectionView: View {
    let position: PositionListModel
    let unit: UnitListModel
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let holiday: Int
    let penaltyUnderperformance: Int
    let incentivesOvertime: Int
    let absenceForReason: Int
    
    @StateObject private var userList = GetUsersSelection()
    @State private var selectedUser: UserByUnitPositionModel?
    @State private var showReports = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                // Заголовок и кнопки
                TittleGray(tittle: "Выбор пользователя")
                
                Spacer()
                
                if userList.isLoading {
                    SetLottieView(name: "Loading")
                    Spacer()
                } else if userList.users.isEmpty {
                    Text("Пользователи не найдены")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                                    HStack {
                                        VStack(spacing: 10) {
                                            Text("Выбранная должность")
                                                .font(.headline)
                                                .foregroundColor(.gray)
                                            Text(position.name)
                                                .font(.subheadline)
                                        }
                                    }
                                    .frame(maxWidth: .infinity) // Растягиваем HStack на всю ширину
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity)
                        LazyVStack(spacing: 10) {
                            ForEach(userList.users) { user in
                                HStack {
                                    Text("\(user.firstName) \(user.lastName)")
                                    Spacer()
                                    ZStack {
                                        Circle()
                                            .fill(Color("Primary"))
                                            .opacity(0.1)
                                            .frame(width: 30, height: 30)
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color("Primary"))
                                    }
                                }

                                .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(selectedUser?.id == user.id ? Color.green.opacity(0.2) : Color(.systemGray6))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        selectedUser = user
                                        showReports = true
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 40)
                    }
                    .scrollIndicators(.hidden)
                }
                
                Spacer()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Выбор пользователя")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                userList.getUsers(unit: unit.name, position: position.name)
            }
            .fullScreenCover(isPresented: $showReports) {
                if let selectedUser = selectedUser {
                    ReportsChartsView(
                        firstName:selectedUser.lastName,
                        lastName: selectedUser.firstName,
                        startDate: startDate,
                        endDate: endDate,
                        startTime: startTime,
                        endTime: endTime,
                        holiday: holiday,
                        penaltyUnderperformance: penaltyUnderperformance,
                        incentivesOvertime: incentivesOvertime,
                        absenceForReason: absenceForReason
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}
