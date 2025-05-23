//
//  TopListView.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 08.04.2025.
//

import SwiftUI


struct TopListView: View {
    
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let type: String
    let holiday: Int
    let allowedUnits: [String]
    
    @StateObject private var topListManager = GetTopList()
    @State var selectUser: TopListBodyModel?
    @State var showChart = false
    
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
        VStack {
            TittleGray(tittle: "Топ по \(formatTittle(type: type))")
            Spacer()
            
            VStack {
                if topListManager.isLoadinng {
                    SetLottieView(name: "Loading")
                    Spacer()
                } else if topListManager.topList.isEmpty {
                    Text("Нет данных для отображения")
                        .foregroundStyle(Color.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    tableView
                        .scrollIndicators(.hidden)
                }
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .onAppear {
                topListManager.getTopList(
                    startDate: startDate,
                    endDate: endDate,
                    startTime: startTime,
                    endTime: endTime,
                    holidays: holiday,
                    allowedUnits: allowedUnits,
                    type: type
                )
                
            }

            
        }
        .ignoresSafeArea()
        .fullScreenCover(item: $selectUser, content: { user in
            ReportsChartsView(
                firstName: user.lastName,
                lastName:  user.firstName,
                startDate: startDate,
                endDate: endDate,
                startTime: startTime,
                endTime: endTime,
                holiday: holiday,
                penaltyUnderperformance: 30,
                incentivesOvertime: 15,
                absenceForReason: 0
            )
        })
       
    }
    
    
    private var tableView: some View {
        List(topListManager.topList) { employee in
            Button {
                selectUser = employee
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(" \(employee.lastName) \(employee.firstName) \(employee.secondName)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(employee.position)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 5) {
                        switch type {
                        case "Опоздания":
                            Text("\(employee.lateDays) дн.")
                                .font(.subheadline)
                            Text(String(format: "%.1f ч", employee.lateHours))
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        case "Переработки":
                            Text(String(format: "%.1f ч", employee.overtimeHours))
                                .font(.subheadline)
                        case "Недоработки":
                            Text(String(format: "%.1f ч", employee.underworkedHours))
                                .font(.subheadline)
                        case "Пропуски":
                            Text("\(employee.missedDays) дн.")
                                .font(.subheadline)
                        default:
                            Text("-")
                        }
                    }
                }
            }
            .padding(.vertical, 5)
        }
        .listStyle(PlainListStyle())
    }
    
    private func formatDisplayDate(from dateString: String) -> String {
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        return displayFormatter.string(from: date)
    }
    func formatTittle(type: String) -> String {
        switch type {
        case "Опоздания":
            return "опозданиям"
        case "Пропуски":
            return "пропускам"
        case "Недоработки":
            return "недоработкам"
        case "Переработки":
            return "перерабокам"
        default:
            return "N/A"
        }
    }
}
