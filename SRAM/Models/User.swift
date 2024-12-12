//
//  User.swift
//  SRAM
//
//  Created by Sofia Wong on 12/9/24.
//

import Foundation

struct User {
  let access_token: String
  let refresh_token: String
  let expires_at: Date
  let athlete: AthleteSummary
  
  init(response: StravaToken) {
    self.access_token = response.access_token
    self.refresh_token = response.refresh_token
    self.expires_at = Date(timeIntervalSince1970: TimeInterval(response.expires_at))
    self.athlete = response.athlete
  }
}
