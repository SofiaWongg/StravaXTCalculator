//
//  ActivityConversions.swift
//  SRAM
//
//  Created by Sofia Wong on 12/10/24.
//

import Foundation

//conversion ratios from one activity type to another
let conversionMatrix: [ActivityTypes: [ActivityTypes: Double]] = [
    .run : [.run: 1.0, .swim: 0.25, .bike: 3.0],
    .swim: [.run: 4.0, .swim: 1.0, .bike: 12.0],
    .bike: [.run: 0.33, .swim: 0.083, .bike: 1.0]
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
  var mileCounter: [ActivityTypes: Double] = [.run: 0, .swim: 0, .bike:0]
  for activity in activities{
    switch activity.type {
    case "Run":
      mileCounter[.run, default: 0] += activity.distance
    case "Swim":
      mileCounter[.swim , default: 0] += activity.distance
    case "Bike":
      mileCounter[.bike , default: 0] += activity.distance
    default:
      continue
    }
  }
  return mileCounter
}

//converts distance from meters to miles and to two decimal places
func toMiles(distanceInMeters: Double) -> Double {
    let metersPerMile = 1609.34
    return (distanceInMeters / metersPerMile * 100).rounded() / 100
}
