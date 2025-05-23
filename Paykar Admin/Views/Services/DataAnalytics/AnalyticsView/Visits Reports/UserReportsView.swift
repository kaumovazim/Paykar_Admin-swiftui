import SwiftUI

struct UserReportsView: View {
    let firstName: String
    let lastName: String
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let holiday: Int
    let penaltyUnderperformance: Int
    let incentivesOvertime: Int
    let absenceForReason: Int
    
    @StateObject private var reportsData = GetUserReportsData()
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingVisitsSheet = false // Состояние для управления показом .sheet
    
    var body: some View {
        ZStack {
            VStack {
                // Заголовок и кнопки
                TittleGray(tittle: "Выбор позиции")
                
                Spacer()
                
                // Отображение данных отчета
                if reportsData.isLoading {
                    SetLottieView(name: "Loading")
                    Spacer()
                } else if reportsData.userData.isEmpty {
                    Text("Данные не найдены")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            if let report = reportsData.userData.first {
                                // Основные показатели
                                
                                ReportRow(title: "Рабочих дней в месяце", value: "\(report.workDaysInMonth ?? 0)")
                                    .foregroundStyle(Color.green)
                                ReportRow(title: "Отработано дней", value: "\(report.workedDays ?? 0)")
                                    .foregroundStyle(Color.green)
                                ReportRow(title: "Пропущено дней (по причине)", value: "\(report.absenceForReason ?? 0)")
                                    .foregroundStyle(Color.green)
                                ReportRow(title: "Пропущено дней", value: "\(report.missedDays ?? 0)")
                                    .foregroundStyle(Color.red)
                                ReportRow(title: "Опоздания в днях", value: "\(report.lateDays ?? 0)")
                                    .foregroundStyle(Color.red)
                                ReportRow(title: "Часы опозданий", value: report.totalLateHours ?? "0")
                                    .foregroundStyle(Color.red)
                                ReportRow(title: "Переработоки в днях", value: "\(report.overtimeDays ?? 0)")
                                ReportRow(title: "Часы переработки", value: report.totalOvertimeHours ?? "0")
                                ReportRow(title: "Недоработанные часы", value: report.totalUnderworkedHours ?? "0")
                                ReportRow(title: "Ожидаемые часы", value: report.expectedHours ?? "0")
                                ReportRow(title: "Отработанные часы", value: report.totalWorkedHours ?? "0")
                                ReportRow(title: "Поощрение", value: "\(String(format: "%.2f", report.encouragement ?? 0)) с.")
                                    .foregroundStyle(Color.green)
                                ReportRow(title: "Штраф", value: "\(String(format: "%.2f", report.penaltyAmount ?? 0)) c.")
                                    .foregroundStyle(Color.red)
                                ReportRow(title: "Разница часов", value: report.hoursDifference ?? "0")
                                ReportRow(title: "Короткие дни", value: "\(report.shortDays ?? 0)")
                                ReportRow(title: "Длинные дни", value: "\(report.longDays ?? 0)")
                                ReportRow(title: "Среднее время входа", value: report.avgFirstEntryFormatted ?? "N/A")
                                ReportRow(title: "Среднее время выхода", value: report.avgLastExitFormatted ?? "N/A")
                                ReportRow(title: "Выполненная норма", value: "\(String(format: "%.2f", report.performancePercentage ?? 0.0))%")
                                    .foregroundStyle(report.performancePercentage ?? 0.0 <= 80.0 ? Color.red : Color.green)
                                
                                // Строка для посещений

                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 20)
                    }
                    .scrollIndicators(.hidden)
                    Button(action: {
                        isShowingVisitsSheet = true
                    }) {
                        Text("Журнал посещений")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .fullScreenCover(isPresented: $isShowingVisitsSheet) {
                        if let report = reportsData.userData.first {
                            VisitsSheetView(visits: report.visitList ?? [] )
                        }
                    }
                }
                
                Spacer()
            }
            .background(Color(.systemBackground))
            .onAppear {
                reportsData.getData(
                    firstName: firstName,
                    lastName: lastName,
                    startDate: startDate,
                    endDate: endDate,
                    startTime: startTime,
                    endTime: endTime,
                    holiday: holiday,
                    penaltyUnderperformance: penaltyUnderperformance,
                    incentivesOvertime: incentivesOvertime,
                    absenceForReason: absenceForReason
                )
                print("\(firstName) \(lastName)")
            }
        }
        .ignoresSafeArea()
    }
}

// Вспомогательный компонент для отображения строки отчета
struct ReportRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text("\(value)")
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
struct VisitStack: View {
    @State var date: String
    @State var workTime: String
    @State var enter: String
    @State var exit: String
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(alignment: .lastTextBaseline) {
                Text(date)
                    .padding(.horizontal, 8)
                Spacer()
                Text(workTime)
                    .font(.headline)
                    .padding(.horizontal, 8)
            }
            .padding()
            .background(Capsule().fill(Color(.systemGray6))) // Добавляем капсулу как фон
            .cornerRadius(10)
            .padding(.vertical, 5)
            HStack {
                HStack(spacing: 3) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 45, height: 45)
                        Image("logoutNew")
                            .renderingMode(.template)
                            .foregroundStyle(Color.green)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Приход")
                            .font(.system(size: 13))
                        Text(enter)
                            .font(.headline)
                    }
                    .padding(.horizontal, 5)
                }
                Spacer()
                HStack(spacing: 3) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 50, height: 50)
                        Image("logoutNew")
                            .renderingMode(.template)
                            .rotationEffect(Angle(degrees: 180))
                            .foregroundStyle(Color.green)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Уход")
                            .font(.system(size: 13))
                        Text(exit)
                            .font(.headline)
                    }
                    .padding(.horizontal, 5)
                }
            }
        }
    }
}
// Новое представление для отображения данных о посещениях в .sheet
struct VisitsSheetView: View {
    let visits: [VisitListModel]
    var convert = MainManager()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                // Заголовок и кнопки
                TittleGray(tittle: "Журнал посещений")
                
                Spacer()
                ScrollView {
                    LazyVStack(spacing: 15) {
                        if visits.isEmpty {
                            Text("Нет данных о посещениях")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(visits, id: \.self) { visit in
                                VisitStack(date: convert.formattedDate(from: visit.WorkDate ?? " "), workTime: visit.TimeDifference ?? " ", enter: visit.FirstEntry ?? " ", exit: visit.LastExit ?? " ")
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
        }
        .ignoresSafeArea()
    }
}
