//
//  User.swift
//  SRAM
//
//  Created by Sofia Wong on 12/9/24.
//

import Foundation

struct User {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
    let athlete: AthleteSummary

    init(response: StravaToken) {
        self.accessToken = response.access_token
        self.refreshToken = response.refresh_token
        self.expiresAt = Date(timeIntervalSince1970: TimeInterval(response.expires_at))
        self.athlete = response.athlete
    }
}
