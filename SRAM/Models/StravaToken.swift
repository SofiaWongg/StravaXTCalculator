//
//  StravaToken.swift
//  SRAM
//
//  Created by Sofia Wong on 12/8/24.
//

import Foundation

//Example Response:
//{
//  "token_type": "Bearer",
//  "expires_at": 1568775134,
//  "expires_in": 21600,
//  "refresh_token": "e5n567567...",
//  "access_token": "a4b945687g...",
//  "athlete": {
//    #{summary athlete representation}
//  }
//}

struct StravaToken: Codable {
  let expires_at: Int
  let refresh_token: String
  let access_token: String
  let athlete: AthleteSummary
  
}
