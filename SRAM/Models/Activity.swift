//
//  Activity.swift
//  SRAM
//
//  Created by Sofia Wong on 12/9/24.
//

import Foundation

struct Activity: Codable{
  let id: Int
  let name: String
  let moving_time: Int //seconds
  let type: String
  let distance: Double //meters
  let start_date: String
  
  //Value added to get date format
  var startDateFormatted: Date? {
    let dateFormatter = ISO8601DateFormatter()
    return dateFormatter.date(from: start_date)
  }
}
