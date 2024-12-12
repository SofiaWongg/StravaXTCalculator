//
//  AthleteSummary.swift
//  SRAM
//
//  Created by Sofia Wong on 12/9/24.
//

import Foundation

struct AthleteSummary: Codable {
    let id: Int
    let username: String?
    let firstname: String
    let lastname: String
    let profilePicture: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case firstname
        case lastname
        case profilePicture = "profile"
    }
}