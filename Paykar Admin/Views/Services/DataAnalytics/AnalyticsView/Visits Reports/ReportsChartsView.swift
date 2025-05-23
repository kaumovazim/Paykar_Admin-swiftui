//
//  ChartsView.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 04.04.2025.
//

import SwiftUI
import Charts

struct ReportsChartsView: View {
    var firstName: String
    var lastName: String
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let holiday: Int
    let penaltyUnderperformance: Int
    let incentivesOvertime: Int
    let absenceForReason: Int
    
    @StateObject private var reportsData = GetUserReportsData()
    @State private var isShowingNextScreen = false
    @Environment(\.dismiss) private var dismiss // Для закрытия экрана

    
    var body: some View {
        ZStack {
            VStack {
                // Заголовок и кнопки
                TittleGray(tittle: "График отчетов")
                
                Spacer()
                
                ScrollView {
                    VStack(spacing: 30) {
                        if let report = reportsData.userData.first {
                            // 1. Круговая диаграмма: отработанные и пропущенные дни
                            PieChartView(workedDays: report.workedDays ?? 0, missedDays: report.missedDays ?? 0)
                                .frame(height: 200)
                                .padding(.bottom, 15)
                            
                            // 2. Столбчатая диаграмма: ожидаемые vs отработанные часы
                            HoursBarChartView(expectedHours: Double(report.expectedHours ?? "0") ?? 0,
                                              totalWorkedHours: Double(report.totalWorkedHours ?? "0") ?? 0)
                            .frame(height: 200)
                            .padding(.bottom, 15)
                            
                            // 3. Линейный график: переработка по дням
                            OvertimeLineChartView(overtimeHours: report.overTimeHours)
                                .frame(height: 200)
                                .padding(.bottom, 15)
                            LateHoursBarChartView(lateHours: report.lateHours) // Передаём новый тип
                                .frame(height: 200)
                                .padding(.bottom, 15)
                            
                            Button(action: {
                                isShowingNextScreen = true
                            }) {
                                Text("Подробнее")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(25)
                                    .shadow(radius: 5)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 20)
                        }
                    }
                    .padding()
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
                            absenceForReason:absenceForReason
                            
                        )
                    }
                    .fullScreenCover(isPresented: $isShowingNextScreen) {
                        UserReportsView(
                            firstName: firstName,
                            lastName: lastName,
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
                .scrollIndicators(.hidden)
            }
        }.ignoresSafeArea()

    }
}
// 1. Круговая диаграмма
struct PieChartView: View {
    let workedDays: Int
    let missedDays: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Дни в месяце")
                .font(.headline)
            Chart {
                SectorMark(
                    angle: .value("Дни", workedDays <= 0 ? 0 : workedDays),
                    innerRadius: .ratio(0.4),
                    angularInset: 1.0
                )
                .foregroundStyle(.green)
                .annotation(position: .overlay) {
                    Text("Отработано: \(workedDays)")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                
                SectorMark(
                    angle: .value("Дни", missedDays <= 0 ? 0 : missedDays ),
                    innerRadius: .ratio(0.4),
                    angularInset: 1.0
                )
                .foregroundStyle(.red)
                .annotation(position: .overlay) {
                    Text("Пропущено: \(missedDays)")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            .chartLegend(.visible)
        }

    }
}

// 2. Столбчатая диаграмма
struct HoursBarChartView: View {
    let expectedHours: Double
    let totalWorkedHours: Double
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Сравнение часов")
                .font(.headline)
            Chart {
                BarMark(x: .value("Категория", "Ожидаемые часы"), y: .value("Часы", expectedHours))
                    .foregroundStyle(.blue)
                BarMark(x: .value("Категория", "Отработанные часы"), y: .value("Часы", totalWorkedHours))
                    .foregroundStyle(.green)
            }
            .chartLegend(.visible)
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
        }
    }
}

// 3. Линейный график
struct OvertimeLineChartView: View {
    let overtimeHours: [OvertimeHours]? // Обновляем тип данных
    
    struct OvertimeData: Identifiable {
        let id = UUID()
        let date: String // Используем дату вместо номера дня
        let hours: Double
    }
    
    var data: [OvertimeData] {
        // Преобразуем массив OvertimeHours в массив OvertimeData
        overtimeHours?.map { overtime in
            OvertimeData(
                date: overtime.date ?? "Неизвестно", // Если дата nil, используем заглушку
                hours: Double(overtime.overtimeHours ?? "0") ?? 0 // Преобразуем строку в Double
            )
        } ?? [] // Если overtimeHours nil, возвращаем пустой массив
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Переработка по дням")
                .font(.headline)
            Chart(data) { item in
                LineMark(
                    x: .value("Дата", item.date), // Используем дату как метку по оси X
                    y: .value("Часы переработки", item.hours)
                )
                .foregroundStyle(.green)
                
                PointMark(
                    x: .value("Дата", item.date),
                    y: .value("Часы переработки", item.hours)
                )
                .foregroundStyle(.green)
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in // Автоматические метки для дат
                    AxisGridLine()
                    AxisValueLabel(formatDay(value.as(String.self) ?? ""))
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .frame(height: 200) // Устанавливаем фиксированную высоту для графика
        }
    }
    // Функция для извлечения только дня
    private func formatDay(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Формат входной даты
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "d" // Только день
            return formatter.string(from: date)
        }
        return dateString // Если парсинг не удался, возвращаем исходное
    }
}

struct LateHoursBarChartView: View {
    let lateHours: [LateHours]?
        
        struct LateData: Identifiable {
            let id = UUID()
            let date: String
            let hours: Double
        }
        
        var data: [LateData] {
            lateHours?.map { late in
                LateData(
                    date: late.date ?? "Неизвестно",
                    hours: Double(late.lateHours ?? "0") ?? 0
                )
            } ?? []
        }
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Опоздания по дням")
                    .font(.headline)
                Chart(data) { item in
                    LineMark(
                        x: .value("Дата", item.date),
                        y: .value("Часы опоздания", item.hours)
                    )
                    .foregroundStyle(.orange)
                    
                    PointMark(
                        x: .value("Дата", item.date),
                        y: .value("Часы опоздания", item.hours)
                    )
                    .foregroundStyle(.orange)
                    .symbolSize(30) // Небольшие точки для обозначения значений
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisValueLabel(formatDay(value.as(String.self) ?? ""))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                .frame(height: 200)
            }
        }
    // Функция для извлечения только дня
    private func formatDay(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Формат входной даты
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "d" // Только день
            return formatter.string(from: date)
        }
        return dateString // Если парсинг не удался, возвращаем исходное
    }
}
