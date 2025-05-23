//
//  StoryModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 21/09/24.
//

import Foundation

struct GroupItem: Codable, Identifiable {
    var id: Int
    var name: String
    var picture: String
}

struct Group: Codable, Identifiable {
    var id: Int { groupId }
    var groupId: Int
    var groupName: String
    var groupPicture: String
    var groupItemList: [GroupItem]
}

struct CreateStoryResponse: Decodable {
    var success: Bool
    var message: String
}
struct UploadResponse: Decodable {
    let status: String
    let message: String
    let file_link: String?
}
