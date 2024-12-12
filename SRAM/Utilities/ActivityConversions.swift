//
//  ActivityConversions.swift
//  SRAM
//
//  Created by Sofia Wong on 12/10/24.
//

import Foundation

//conversion ratios from one activity type to another
let conversionMatrix: [ActivityTypes: [ActivityTypes: Double]] = [
    .run : [.run: 1.0, .swim: 0.25, .ride: 3.0],
    .swim: [.run: 4.0, .swim: 1.0, .ride: 12.0],
    .ride: [.run: 0.33, .swim: 0.083, .ride: 1.0]
]

//converts one event distance to another using conversion matrix values
func convertDistance(from: ActivityTypes, to: ActivityTypes, distance: Double) -> Double? {
    guard let fromConversions = conversionMatrix[from],
          let conversionRatio = fromConversions[to] else {
        print("Conversion from \(from.rawValue) to \(to.rawValue) is not defined")
        return nil
    }
    return distance * conversionRatio
}

func sortActivities(activities: [Activity]) -> [ActivityTypes: Double] {
  var mileCounter: [ActivityTypes: Double] = [.run: 0, .swim: 0, .ride:0]
  for activity in activities{
    switch activity.type {
    case "Run":
      mileCounter[.run, default: 0] += activity.distance
    case "Swim":
      mileCounter[.swim , default: 0] += activity.distance
    case "Ride":
      mileCounter[.ride , default: 0] += activity.distance
    default:
      continue
    }
  }
  return mileCounter
}

func toMiles(distanceInMeters: Double) -> String {
    let metersPerMile = 1609.34
    let miles = distanceInMeters / metersPerMile
    return String(format: "%.2f", miles)
}

func getMileageByWeek(activities: [Activity], weeks: Int) -> [Date: [ActivityTypes: Double]] {
  if activities.isEmpty{
    return [:]
  }
  
  var weeklyMileage: [Date: [ActivityTypes: Double]] = [:]
  let currentTime = Int(Date().timeIntervalSince1970)
  var endOfWeek = currentTime
  
  var weekCounter  = 0
  
  while(weekCounter < weeks){
    let startOfWeek = getEpochTimestampStart(endOfWeek: endOfWeek)
    
    //Creating dictionary key
    let weekStartDate = Date(timeIntervalSince1970: Double(startOfWeek))
    
    
    let weeklyActivities = activities.filter {activity in
      
      //assuring has properly formatted date
      guard let activityDate = activity.startDateFormatted else {
        return false
      }
      
      return activityDate.timeIntervalSince1970 >= Double(startOfWeek) &&
      activityDate.timeIntervalSince1970 < Double(endOfWeek)
    }
    
    weeklyMileage[weekStartDate] =  sortActivities(activities: weeklyActivities)
    
    print("Week Start: \(weekStartDate), Week End: \(Date(timeIntervalSince1970: Double(endOfWeek))) Activities: \(weeklyActivities.count)")
    // Move to prev week
    endOfWeek = startOfWeek - 1 //1 second diff
    weekCounter += 1
  }
  
  print(weeklyMileage)
  return weeklyMileage
}
