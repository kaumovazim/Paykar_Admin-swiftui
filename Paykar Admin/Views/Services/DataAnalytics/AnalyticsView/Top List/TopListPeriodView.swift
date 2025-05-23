//
//  TopListPeriodView.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 07.04.2025.
//

import SwiftUI

struct TopListPeriodView: View {
    private let months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    private let years = Array(2020...2030)
    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    private let holiday = Array(0...10)
    private let type = ["Переработки", "Недоработки", "Опоздания", "Пропуски"]
    
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var startHour = 9
    @State private var startMinute = 0
    @State private var endHour = 18
    @State private var endMinute = 0
    @State private var standartHoliday = 0
    @State var isShowingNextScreen = false
    @State var setType = "Переработки"
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var monthStart: String {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonthIndex + 1
        components.day = 1
        let startDate = Calendar.current.date(from: components) ?? Date()
        return dateFormatter.string(from: startDate)
    }
        
    var monthEnd: String {
        let calendar = Calendar.current
        let now = Date() // Текущая дата
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        let currentDay = calendar.component(.day, from: now)
        
        let selectedMonth = selectedMonthIndex + 1
        let selectedComponents = DateComponents(year: selectedYear, month: selectedMonth)
        guard let startDate = calendar.date(from: selectedComponents) else { return dateFormatter.string(from: now) }
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: startDate) else { return dateFormatter.string(from: now) }
        guard let lastDayOfMonth = calendar.date(byAdding: .second, value: -1, to: nextMonth) else { return dateFormatter.string(from: now) }
        
        // Проверяем, завершился ли месяц
        if selectedYear > currentYear || (selectedYear == currentYear && selectedMonth > currentMonth) {
            // Месяц в будущем — используем последний день месяца
            return dateFormatter.string(from: lastDayOfMonth)
        } else if selectedYear == currentYear && selectedMonth == currentMonth {
            // Текущий месяц — используем сегодняшнюю дату
            let todayComponents = DateComponents(year: currentYear, month: currentMonth, day: currentDay)
            guard let today = calendar.date(from: todayComponents) else { return dateFormatter.string(from: now) }
            return dateFormatter.string(from: today)
        } else {
            // Прошлый месяц — используем последний день месяца
            return dateFormatter.string(from: lastDayOfMonth)
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                TittleGray(tittle: "Выбор периода")
                Spacer()

                VStack(alignment: .leading, spacing: 30) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Месяц")
                                    .font(.headline)
                            }
                            HStack(spacing: 20) {
                                Picker("Месяц", selection: $selectedMonthIndex) {
                                    ForEach(0..<months.count, id: \.self) { index in
                                        Text(months[index]).tag(index)
                                    }
                                }
                                .pickerStyle(.menu)
                                Spacer(minLength: 0)
                                Picker("Год", selection: $selectedYear) {
                                    ForEach(years, id: \.self) { year in
                                        Text(String(year)).tag(year)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .shadow(radius: 3)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Рабочий день")
                                    .font(.headline)
                                Spacer()
                                Text("\(String(format: "%02d:%02d", startHour, startMinute)) - \(String(format: "%02d:%02d", endHour, endMinute))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            HStack(spacing: 20) {
                                VStack {
                                    Text("Начало")
                                        .font(.subheadline)
                                    HStack(spacing: 10) {
                                        Picker("Часы", selection: $startHour) {
                                            ForEach(hours, id: \.self) { hour in
                                                Text(String(format: "%02d", hour)).tag(hour)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        Picker("Минуты", selection: $startMinute) {
                                            ForEach(minutes, id: \.self) { minute in
                                                Text(String(format: "%02d", minute)).tag(minute)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                    }
                                }
                                Spacer()
                                VStack {
                                    Text("Конец")
                                        .font(.subheadline)
                                    HStack(spacing: 10) {
                                        Picker("Часы", selection: $endHour) {
                                            ForEach(hours, id: \.self) { hour in
                                                Text(String(format: "%02d", hour)).tag(hour)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        Picker("Минуты", selection: $endMinute) {
                                            ForEach(minutes, id: \.self) { minute in
                                                Text(String(format: "%02d", minute)).tag(minute)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .shadow(radius: 3)
                            
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Праздничные дни")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack(spacing: 20) {
                                Picker("Выходные", selection: $standartHoliday) {
                                    ForEach(holiday, id: \.self) { holiday in
                                        Text(String(holiday)).tag(holiday)
                                    }
                                }
                                .pickerStyle(.menu)
                                Spacer()
                                
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .shadow(radius: 3)
                            
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Топ лист")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack(spacing: 20) {
                                Picker("тип", selection: $setType) {
                                    ForEach(type, id: \.self) { type in
                                        Text(String(type)).tag(type)
                                    }
                                }
                                .pickerStyle(.menu)
                                Spacer()
                                
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .shadow(radius: 3)
                            
                            
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Button(action: {
                        isShowingNextScreen = true
                    }) {
                        Text("Далее")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                }
                

                
                
            }
            .fullScreenCover(isPresented: $isShowingNextScreen) {
                TypeSelect(
                    startDate: monthStart,
                    endDate: monthEnd,
                    startTime: String(format: "%02d:%02d", startHour, startMinute),
                    endTime: String(format: "%02d:%02d", endHour, endMinute),
                    holiday: standartHoliday,
                    type: setType
                )
            }
            
        }.ignoresSafeArea()
        
    }
}
