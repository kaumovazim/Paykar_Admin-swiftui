import Foundation

struct UserReportsDataModel: Codable, Hashable {
    let workDaysInMonth: Int?
    let workedDays: Int?
    let missedDays: Int?
    let absenceForReason: Int?
    let lateDays: Int?
    let totalLateHours: String?
    let overtimeDays: Int?
    let totalOvertimeHours: String?
    let totalUnderworkedHours: String?
    let lateHours: [LateHours]?
    let overTimeHours: [OvertimeHours]?
    let expectedHours: String?
    let totalWorkedHours: String?
    let encouragement: Double?
    let penaltyAmount: Double?
    let hoursDifference: String?
    let shortDays: Int?
    let longDays: Int?
    let avgFirstEntryFormatted: String?
    let avgLastExitFormatted: String?
    let performancePercentage: Double?
    let visitList: [VisitListModel]?
}

struct VisitListModel: Codable, Hashable {
    let Userid: String?
    let UserCode: String?
    let firstName: String?
    let lastName: String?
    let secondName: String?
    let tabelID: String?
    let position: String?
    let unit: String?
    let status: String?
    let depositsDate: String?
    let dismissalsDate: String?
    let WorkDate: String?
    let FirstEntry: String?
    let LastExit: String?
    let TimeDifference: String?
    
    // Реализация Hashable
    static func ==(lhs: VisitListModel, rhs: VisitListModel) -> Bool {
        lhs.Userid == rhs.Userid && lhs.WorkDate == rhs.WorkDate && lhs.FirstEntry == rhs.FirstEntry && lhs.LastExit == rhs.LastExit
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Userid)
        hasher.combine(WorkDate)
        hasher.combine(FirstEntry)
        hasher.combine(LastExit)
    }
}
struct UserReportParameterModel: Codable, Hashable {
    var firstName: String
    var lastName: String
    var startDate: String
    var endDate: String
    var startTime: String
    var endTime: String
    var holidays: Int
    var penaltyUnderperformance: Int
    var incentivesOvertime: Int
    var absenceForReason: Int
}

struct LateHours: Codable, Hashable {
    var date: String?
    var lateHours: String?
}
struct OvertimeHours: Codable, Hashable {
    var date: String?
    var overtimeHours: String?
}

