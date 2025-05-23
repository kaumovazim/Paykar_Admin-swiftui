import SwiftUI
import Alamofire

struct UnitSelectionView: View {
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let holiday: Int
    let penaltyUnderperformance: Int
    let incentivesOvertime: Int
    let absenceForReason:Int
    
    @StateObject private var unitList = UnitList()
    @State private var selectedUnit: UnitListModel?
    @State private var isShowingNextScreen = false
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()

    
    
    var body: some View {
        ZStack {
            VStack {
                // Заголовок и кнопки
                TittleGray(tittle: "Выбор подразделения")
                
                Spacer()

                if unitList.isLoading {
                    SetLottieView(name: "Loading")
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                                    Text("Выбранный период")
                                        .font(.headline)
                            HStack(spacing: 10) {
                                        VStack(alignment: .leading) {
                                            Text("Дата")
                                                .font(.subheadline)
                                            Text("\(formatDisplayDate(from: startDate))")
                                                .foregroundStyle(Color.gray)
                                            Text("\(formatDisplayDate(from: endDate))")
                                                .foregroundStyle(Color.gray)
                                        }
                                        .padding(.horizontal, 20)
                                    Spacer(minLength: 0)
                                        VStack(alignment: .trailing) {
                                            Text("Время")
                                                .font(.subheadline)
                                            Text("\(startTime) - \(endTime)")
                                                .foregroundStyle(Color.gray)
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 40)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                                .padding(.vertical, 30)
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                
                        LazyVStack(spacing: 10) {
                            ForEach(unitList.units) { unit in
                                HStack {
                                    Text(unit.name)
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
                                .background(selectedUnit?.id == unit.id ? Color.green.opacity(0.2) : Color(.systemGray6))
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedUnit = unit
                                    isShowingNextScreen = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .background(Color(.systemBackground))
            .onAppear {
                unitList.getUnitName()
            }
            .fullScreenCover(isPresented: $isShowingNextScreen) {
                if let selectedUnit = selectedUnit {
                    PositionSelectionView(
                        unit: selectedUnit, // Передаем объект UnitListModel
                        startDate: startDate,
                        endDate: endDate,
                        startTime: startTime,
                        endTime: endTime,
                        holiday: holiday,
                        penaltyUnderperformance: penaltyUnderperformance,
                        incentivesOvertime: incentivesOvertime,
                        absenceForReason:absenceForReason
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
    private func formatDisplayDate(from dateString: String) -> String {
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        return displayFormatter.string(from: date)
    }
}
