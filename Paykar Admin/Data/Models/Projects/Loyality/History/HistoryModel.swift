//
//  HistoryModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import Foundation

struct CardHistoryModel: Codable, Hashable, Identifiable {
    var id: Int? {
        return DocumentId
    }
    var DocumentId: Int?
    var DocumentDate: String?
    var CreateDate: String?
    var SubjectId: Int?
    var Subject: String?
    var SubjectFullAdress: String?
    var DocumentCode: String?
    var DocumentFiscalCode: String?
    var TotalSum: Double?
    var TotalSumDiscounted: Double?
    var DocumentTypeName: String?
    var DocumentTypeId: Int?
    var Description: String?
    var AddBonus: Double?
    var RemoveBonus: Double?
    var AddTurnover: Double?
    var RemoveTurnover: Double?
    var Discount: Double?
    var CardId: Int?
    var CardCode: String?
    var CardsString: String?
    var PhonesString: String?
    var AccountTypeId: Int?
    var Cards: [HistoryCards]?
    var DocumentDetails: [HistoryDetails]?
    var DiscountPercent: Double?
    var AccessUserName: String?
    var CashName: String?
    var CashId: Int?
    var CashierId: Int?
    var CashierName: String?
    var AddChips: Double?
    var RemoveChips: Double?
    var PaymentFormId: Int?
    var PaymentForm: String?
    var DocumentPayments: [DocumentPayment]?
    var Comment: String?
    var CompanyId: Int?
    var CompanyName: String?
    var BrandName: String?
    var AccountId: Int?
    var CurrentBalance: Double?
    var Processed: Bool?
    var DelayedBonus: Bool?
}

struct HistoryCards: Codable, Hashable {
    var CardId: Int?
    var AccountId: Int?
    var CardCode: String?
    var Blocked: Bool?
    var BlockedString: String?
    var AccumulateOnly: Bool?
    var AccumulateOnlyString: String?
    var CardStatusId: Int?
    var StartDate: String?
    var FinishDate: String?
    var BonusProgramName: String?
    var Algorithm: String?
    var BonusProgramId: Int?
    var BonusProgramTypeId: Int?
    var Balance: Double?
    var Discount: Double?
    var Turnover: Double?
    var HasSales: Bool?
    var IsSuspicious: Bool?
    var CreateByMarketProgramId: Int?
    var CardType: String?
    var AccountTypeName: String?
    var IsPromoCard: Bool?
    var WalletBarCodeFormatId: Int?
    var AccountTypeId: Int?
}

struct HistoryDetails: Codable, Hashable {
    var DocumentDetailId: Int?
    var ProductCode: String?
    var ProductName: String?
    var Quantity: Double?
    var ReturnQuantity: Double?
    var TotalPrice: Double?
    var TotalPriceDiscounted: Double?
    var AddBonus: Double?
    var RemoveBonus: Double?
    var MarketProgramToPos: [String]?
    var SegmentNames: String?
    var AddBonusPercent: Double?
    var RemoveBonusPercent: Double?
    var Comment: String?
    var OrderLinessGrid: Int?
    var Order: Int?
    var Price: Double?
}

struct DocumentPayment: Codable, Hashable {
    var PaymentFormName: String?
    var Sum: Double?
}
