//
//  DateUtils.swift
//  SRAM
//
//  Created by Sofia Wong on 12/9/24.
//

import Foundation


//Function to get epoch timestamp X weeks ago - for API Activity calls
func getEpochTimestamp(weeksAgo: Int = 4, currentTime: Int = Int(Date().timeIntervalSince1970)) -> Int {
    let weeksInSeconds = weeksAgo * 7 * 24 * 60 * 60
    return currentTime - weeksInSeconds
}

//Function to get beginning of week timestamp (weeks always start monday)
func getEpochTimestampStart(endOfWeek: Int) -> Int {
  let endDate = Date(timeIntervalSince1970: Double(endOfWeek))
  
  // Calendar where Monday is 1st day of week
      var calendar = Calendar.current
      calendar.firstWeekday = 2
      calendar.timeZone = TimeZone(secondsFromGMT: 0)! //UTC
  
  //Get moday of week
  guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: endDate)) else {
          return 0
      }
  
  //Set time to 000
  let startOfDay = calendar.startOfDay(for: weekStart)
  
  //convert to epoch format
  return Int(startOfDay.timeIntervalSince1970)
}

func formatDate(_ date: Date) -> String {
     let formatter = DateFormatter()
     formatter.dateFormat = "MMM dd, yyyy" // Example: "Dec 08, 2024"
      formatter.timeZone = TimeZone(secondsFromGMT: 0)
      return formatter.string(from: date)
 }

func formatDateShort(_ date: Date) -> String {
     let formatter = DateFormatter()
     formatter.dateFormat = "MMM dd" // Example: "Dec 08, 2024"
      formatter.timeZone = TimeZone(secondsFromGMT: 0)
      return formatter.string(from: date)
 }

