//
//  unit_Conversions.swift
//  SRAMTests
//
//  Created by Sofia Wong on 12/12/24.
//

import XCTest
@testable import SRAM

final class unit_ActivityConversions: XCTestCase {
  let activityList: [Activity] = [
    Activity(id: 1, name: "Swim 1", moving_time: 1200, type: "Swim", distance: 800, start_date: "2024-11-25T12:10:00Z"),
    Activity(id: 2, name: "Ride 1", moving_time: 3600, type: "Ride", distance: 9000, start_date: "2024-11-28T06:20:00Z"),
    Activity(id: 3, name: "Run 1", moving_time: 2400, type: "Run", distance: 1000, start_date: "2024-12-03T05:20:00Z"),
    Activity(id: 1, name: "Swim 2", moving_time: 1200, type: "Swim", distance: 800, start_date: "2024-11-28T12:10:00Z"),
  ]
  
  func testConvertDistance() {
    XCTAssertEqual(convertDistance(from: .run, to: .swim, distance: 4.0), 1.0)
    XCTAssertEqual(convertDistance(from: .swim, to: .ride, distance: 2.0), 24.0)
    XCTAssertEqual(convertDistance(from: .run, to: .run, distance: 0.0), 0.0)
  }
  
  func testConvertWeeklyMiles() {
    let weeklyMileage: [Date: [ActivityTypes: Double]] = [
      Date(): [.run: 10.0, .swim: 2.0, .ride: 30.0]
    ]
    let converted = convertWeeklyMiles(weeklyMileage: weeklyMileage, targetType: .run)
    guard let firstEntry = converted.values.first else {
      XCTFail("Converted weekly miles should not be empty")
      return
    }
    XCTAssertEqual(firstEntry[.run], 10.0)
    XCTAssertEqual(firstEntry[.swim], 8.0)
    XCTAssertEqual(firstEntry[.ride], 9.9)
  }
  
  func testSortActivities() {
    let activities: [Activity] = activityList.map { $0 }
    let sorted = sortActivities(activities: activities)
    XCTAssertEqual(sorted[.run], 1000.0)
    XCTAssertEqual(sorted[.swim], 1600.0)
    XCTAssertEqual(sorted[.ride], 9000)
  }
  
  func testToStringMiles() {
    XCTAssertEqual(toStringMiles(distanceInMeters: 1609.34), "1.00")
    XCTAssertEqual(toStringMiles(distanceInMeters: 8046.7), "5.00")
  }
  
  func testToMiles() {
    XCTAssertEqual(toMiles(distanceInMeters: 1609.34), 1.0)
    XCTAssertEqual(toMiles(distanceInMeters: 8046.7), 5.0)
  }
  
  func testGetMileageByWeek() {
    let activities: [Activity] = activityList.map { $0 }
    let weeklyMileage = getMileageByWeek(activities: activities, weeks: 4)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    
    guard let date1 = formatter.date(from: "2024-11-18 00:00:00 +0000"),
          let date2 = formatter.date(from: "2024-11-25 00:00:00 +0000"),
          let date3 = formatter.date(from: "2024-12-02 00:00:00 +0000"),
          let date4 = formatter.date(from: "2024-12-09 00:00:00 +0000") else {
      XCTFail("Failed to parse one or more dates")
      return
    }
    
    XCTAssertEqual(weeklyMileage[date1], [.run: 0.0, .swim: 0.0, .ride: 0.0])
    XCTAssertEqual(weeklyMileage[date2], [.run: 0.0, .swim: 1600.0, .ride: 9000.0])
    XCTAssertEqual(weeklyMileage[date3], [.run: 1000.0, .swim: 0.0, .ride: 0.0])
    XCTAssertEqual(weeklyMileage[date4], [.run: 0.0, .swim: 0.0, .ride: 0.0])
  }
  
  
  
}
