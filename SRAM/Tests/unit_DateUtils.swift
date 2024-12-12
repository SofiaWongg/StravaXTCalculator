//
//  unit_DateUtils.swift
//  SRAMTests
//
//  Created by Sofia Wong on 12/12/24.
//

import XCTest
@testable import SRAM

final class unit_DateUtils: XCTestCase {
  
  func testGetEpochTimestamp() {
    let weeksAgo = 4
    let expectedTimestamp = Int(Date().timeIntervalSince1970) - (weeksAgo * 7 * 24 * 60 * 60)
    let actualTimestamp = getEpochTimestamp(weeksAgo: weeksAgo)
    
    XCTAssertEqual(actualTimestamp, expectedTimestamp)
  }
  
  func testGetEpochTimestampStart() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let endDate = formatter.date(from: "2024-12-09 00:00:00 +0000") else {
      XCTFail("Failed to parse test date")
      return
    }
    
    let endOfWeek = Int(endDate.timeIntervalSince1970)
    let startOfWeek = getEpochTimestampStart(endOfWeek: endOfWeek)
    
    var calendar = Calendar.current
    calendar.firstWeekday = 2 // Monday
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    
    guard let expectedStartOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: endDate)) else {
      XCTFail("Failed to calculate expected start of week")
      return
    }
    
    XCTAssertEqual(startOfWeek, Int(expectedStartOfWeek.timeIntervalSince1970))
  }
  
  func testFormatDate() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let testDate = formatter.date(from: "2024-12-09 00:00:00 +0000") else {
      XCTFail("Failed to parse test date")
      return
    }
    
    let formattedDate = formatDate(testDate)
    XCTAssertEqual(formattedDate, "Dec 09, 2024", "The formatted date is incorrect.")
  }
  
  func testFormatDateShort() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let testDate = formatter.date(from: "2024-12-09 00:00:00 +0000") else {
      XCTFail("Failed to parse test date")
      return
    }
    
    let formattedDateShort = formatDateShort(testDate)
    XCTAssertEqual(formattedDateShort, "Dec 09", "The short formatted date is incorrect.")
  }
}
