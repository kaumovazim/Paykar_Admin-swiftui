//
//  ReportsListView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 10/11/24.
//

import SwiftUI

struct ReportsListView: View {
    
    @State var alertConnection = false
    @Environment(\.dismiss) var dismiss
    @StateObject var opencloseManager = OpenCloseReportManager()
    @StateObject var mainManager = MainManager()
    @State var selectedReport: OpenCloseReportModel?
    @State var showFilterSheet = false
    @State var selectedUnit: String = "Все"
    @State var selectedType: String = "Все"
    @State var selectedDate: Date = .now
    @State var makeReport = false
    var body: some View {
        ZStack{
            VStack {
                HStack{
                    Text("Отчеты")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        makeReport = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .fullScreenCover(isPresented: $makeReport) {
                        MakeReportView()
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                
                if opencloseManager.isLoading {
                    Spacer()
                    ProgressView()
                        .padding(.bottom, 100)
                    Spacer()
                } else if filteredReports().isEmpty {
                    Spacer()
                    LottieView(name: "EmptyListAnim")
                        .scaleEffect(CGSize(width: 0.4, height: 0.4))
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 100)
                    Spacer()
                } else {
                    ScrollView{
                        ForEach(filteredReports()) { report in
                            Button {
                                if MainManager().checkInternetConnection() {
                                    selectedReport = report
                                } else {
                                    alertConnection = true
                                }
                            } label: {
                                OpenCloseReportItemView(report: report)
                            }.sheet(item: $selectedReport, content: { report in
                                OpenCloseReportDetailsView(report: report)
                                    .onDisappear() {
                                        if mainManager.checkInternetConnection() {
                                            opencloseManager.openCloseReportList()
                                        } else {
                                            alertConnection = true
                                        }
                                    }
                            })
                            .alert("Что то пошло не так!", isPresented: $alertConnection) {
                                Button("Попробовать еще", role: .cancel, action: {
                                    dismiss()
                                })
                            } message: {
                                Text("Проверьте подключение к Интернету и повторите попытку.")
                            }
                        }
                        .padding(.bottom, 120)
                    }.scrollIndicators(.hidden)
                }
            }
            HStack {
                Button {
                    if mainManager.checkInternetConnection() {
                        opencloseManager.openCloseReportList()
                    } else {
                        alertConnection = true
                    }
                } label: {
                    CustomButton(icon: "arrow.triangle.2.circlepath")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(40)
                Spacer()
                Button {
                    showFilterSheet = true
                } label: {
                    CustomButton(icon: "arrow.up.and.down.text.horizontal")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(40)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showFilterSheet) {
            ReportFilterView(
                selectedUnit: $selectedUnit,
                selectedType: $selectedType,
                selectedDate: $selectedDate
            )
        }
        .onAppear() {
            if mainManager.checkInternetConnection() {
                opencloseManager.openCloseReportList()
            } else {
                alertConnection = true
            }
        }
    }
    
    private func filteredReports() -> [OpenCloseReportModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return opencloseManager.reports.filter { report in
            if let reportDate = dateFormatter.date(from: report.create_date) {
                // Apply filtering conditions if date conversion is successful
                return (selectedUnit == "Все" || report.unit == selectedUnit) &&
                (selectedType == "Все" || report.type == selectedType) &&
                (selectedDate == .now || Calendar.current.isDate(reportDate, equalTo: selectedDate, toGranularity: .day))
            } else {
                return false
            }
        }
    }
}

struct ReportFilterView: View {
    
    @Binding var selectedUnit: String
    @State var unitSheet: Bool = false
    @Binding var selectedType: String
    @State var typeSheet: Bool = false
    @Binding var selectedDate: Date
    @State private var restrictToCurrentMonth = true
    private let calendar = Calendar.current
    private var startOfMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) ?? Date()
    }
    
    private var endOfMonth: Date {
        guard let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth),
              let endOfMonth = calendar.date(byAdding: .day, value: -1, to: startOfNextMonth) else {
            return Date()
        }
        return endOfMonth
    }
    
    private var dateRange: ClosedRange<Date>? {
        restrictToCurrentMonth ? startOfMonth...endOfMonth : nil
    }
    private let units = ["Пайкар 1", "Пайкар 2", "Пайкар 3", "Пайкар 4", "Пайкар 5", "Пайкар 6", "Пайкар 7", "Пайкар 8"]
    private let types = ["Открытие", "Закрытие"]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Text("Фильтр")
                    .font(.title)
                    .bold()
                Spacer()
                Button {
                    selectedDate = .now
                    selectedType = "Все"
                    selectedUnit = "Все"
                    dismiss()
                } label: {
                    Text("Сброс")
                        .foregroundStyle(.red)
                }
            }
            .padding(.top, 30)
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                in: dateRange ?? Date.distantPast...Date.distantFuture,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            Text("Подразделение")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                unitSheet = true
            } label: {
                HStack {
                    Text(selectedUnit)
                        .font(.system(size: 16))
                        .foregroundStyle(Color("Primary"))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName:  "chevron.down")
                        .resizable()
                        .foregroundStyle(Color("Primary"))
                        .frame(width: 15, height: 10)
                }
                .padding(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 2).fill(Color("Primary"))
                }
            }
            .sheet(isPresented: $unitSheet){
                CustomList(update: {},list: units, title: $selectedUnit, close: $unitSheet)
            }
            Text("Тип")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                typeSheet = true
            } label: {
                HStack {
                    Text(selectedType)
                        .font(.system(size: 16))
                        .foregroundStyle(Color("Primary"))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName:  "chevron.down")
                        .resizable()
                        .foregroundStyle(Color("Primary"))
                        .frame(width: 15, height: 10)
                }
                .padding(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 2).fill(Color("Primary"))
                }
            }
            .sheet(isPresented: $typeSheet){
                CustomList(update: {},list: types, title: $selectedType, close: $typeSheet)
            }
            Spacer()
        }
        .padding()
        .ignoresSafeArea()
        .presentationDetents([.height(CGFloat(650))])
    }
}
#Preview {
    ReportsListView()
}


