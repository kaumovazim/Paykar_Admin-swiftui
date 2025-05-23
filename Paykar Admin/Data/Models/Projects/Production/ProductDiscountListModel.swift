//
//  ProductDiscountListModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 01/11/24.
//

import Foundation
import SwiftUI

struct DiscountProgram: Decodable, Identifiable {
    let id: String
    let status: String
    let programName: String
    let department: String
    let discountValue: String
    let dateStart: String
    let dateEnd: String
    let productCode: String
    let productName: String
    let productQuantity: String
    let productImages: [String]
    let user: String
    let responsiblePerson: String
}
